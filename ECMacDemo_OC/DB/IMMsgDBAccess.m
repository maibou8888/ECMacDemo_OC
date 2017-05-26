    /*
 *  Copyright (c) 2013 The CCP project authors. All Rights Reserved.
 *
 *  Use of this source code is governed by a Beijing Speedtong Information Technology Co.,Ltd license
 *  that can be found in the LICENSE file in the root of the web site.
 *
 *                    http://www.yuntongxun.com
 *
 *  An additional intellectual property rights grant can be found
 *  in the file PATENTS.  All contributing project authors may
 *  be found in the AUTHORS file in the root of the source tree.
 */

#import "IMMsgDBAccess.h"
#import "ECTextMessageBody.h"
#import "ECFileMessageBody.h"
#import "ECMessage.h"
#import "ECGroupNoticeMessage.h"
#import "ECGroup.h"
#import <CommonCrypto/CommonDigest.h>
#import "ECPreviewMessageBody.h"
#import "ECRevokeMessageBody.h"

@interface IMMsgDBAccess()
@property (nonatomic, strong) FMDatabase *dataBase;
@end

@implementation IMMsgDBAccess

+(IMMsgDBAccess*)sharedInstance{
    static IMMsgDBAccess* imdbmanager;
    static dispatch_once_t imdbmanageronce;
    dispatch_once(&imdbmanageronce, ^{
        imdbmanager = [[IMMsgDBAccess alloc] init];
    });
    return imdbmanager;
}

- (void)openDatabaseWithUserName:(NSString*)userName {
    if (userName.length==0) {
        return;
    }
    
    //Documents:
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    
    //username md5
    const char *cStr = [userName UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString* MD5 =  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
    
    //数据库文件夹
    NSString * documentsDirectory = [[paths objectAtIndex:0] stringByAppendingPathComponent:MD5];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDir = FALSE;
    BOOL isDirExist = [fileManager fileExistsAtPath:documentsDirectory isDirectory:&isDir];
    if(!(isDirExist && isDir)) {
        BOOL bCreateDir = [fileManager createDirectoryAtPath:documentsDirectory withIntermediateDirectories:YES attributes:nil error:nil];
        if(!bCreateDir) {
            NSLog(@"Create Database Directory Failed.");
        }
        NSLog(@"%@", documentsDirectory);
    }
    
    NSString *dbPath = [documentsDirectory stringByAppendingPathComponent:@"im_demo.db"];
    NSLog(@"db %@",dbPath);
    if (self.dataBase) {
        [self.dataBase close];
        self.dataBase = nil;
    }
    
    self.dataBase = [FMDatabase databaseWithPath:dbPath];
    [self.dataBase open];

    [self memberTableCreate];
    [self IMGroupIDTableCreate];
    [self IMGroupNoticeTableCreate];
    [self sessionTableCreate];
    [self IMTriggerCreate];
}

// 判断指定表是否存在
- (BOOL)checkTableExist:(NSString *)tableName {
    BOOL result = NO;
    NSString* lowtableName = [tableName lowercaseString];
    
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT [sql] FROM sqlite_master WHERE [type] = 'table' AND lower(name) = ?", lowtableName];
    result = [rs next];
    [rs close];
    
    return result;
}

// 创建表
- (void) createTable:(NSString*)tableName sql:(NSString *)createSql {
    
    BOOL isExist = [self.dataBase tableExists:tableName];
    if (!isExist) {
        [self.dataBase executeUpdate:createSql];
    }
}

- (void)memberTableCreate{
    [self createTable:@"userName" sql:@"CREATE table userName (userid TEXT NOT NULL PRIMARY KEY UNIQUE ON CONFLICT REPLACE, nickName TEXT, sex INTEGER)"];
}

/*
 会话表
 字段	类型	约束	备注
 sessionId 	TEXT	会话id
 dateTime 	Long		显示的时间 毫秒
 type 	int		与消息表msgType一样
 text 	Varchar	2048	显示的内容
 unreadCount	int		未读消息数
 sumCount 	int		总消息数
 */

- (void)sessionTableCreate {
    [self createTable:@"session" sql:@"CREATE table session (sessionId TEXT NOT NULL PRIMARY KEY UNIQUE ON CONFLICT REPLACE, dateTime INTEGER,type INTEGER,text varchar(2048),unreadCount INTEGER,sumCount INTEGER,state INTEGER)"];
    if (![self.dataBase columnExists:@"isAt" inTableWithName:@"session"]) {
        [self.dataBase executeUpdate:@"alter table session add isAt integer default 0"];
    }
    if (![self.dataBase columnExists:@"isTop" inTableWithName:@"session"]) {
        [self.dataBase executeUpdate:@"alter table session add isTop integer default 0"];
    }

}

/*
 消息
 ID 	int	自增	主键
 SID	Varchar 	32	会话ID
 msgid	Varchar 	64	消息id
 sender	Varchar 	32	发送者
 receiver	Varchar 	32	接收者
 createdTime	Long		入库本地时间 毫秒
 userData	Varchar	256	用户自定义数据
 msgType	int		消息类型 0:文本 1:多媒体 2:chunk消息 (0-99聊天的消息类型 100-199系统的推送消息类型)
 text	Varchar	2048	文本
 localPath	text		本地路径
 URL	text		下载路径
 state	int		发送状态 -1发送失败 0发送成功 1发送中 2接收成功（默认为0 接收的消息）；
 dstate	int          接收的附件消息下载状态 0未开始下载 1下载中 2下载成功 3下载失败
 serverTime	Long		服务器时间 毫秒
 remark	Varchar	1024	备注
 */

- (NSString*)SessionTableName:(NSString*)sessionid{
    //username md5
    const char *cStr = [sessionid UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    NSString* SessionMD5 =  [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",result[0], result[1], result[2], result[3], result[4], result[5], result[6], result[7],result[8], result[9], result[10], result[11],result[12], result[13], result[14], result[15]];
    
    return [NSString stringWithFormat:@"Chat_%@", SessionMD5];
}

- (NSString*)IMMessageTableCreateWithSession:(NSString*)session {
    
    NSString *tableName = [self SessionTableName:session];
    
    [self createTable:tableName sql:[NSString stringWithFormat:@"CREATE table %@(ID INTEGER PRIMARY KEY AUTOINCREMENT, SID varchar(32), msgid varchar(64),sender varchar(32), receiver varchar(32),createdTime INTEGER, userData varchar(256), msgType INTEGER, text TEXT, localPath TEXT, URL TEXT, state INTEGER, serverTime INTEGER,dstate INTEGER,remark TEXT)", tableName]];
    if (![self.dataBase columnExists:@"isRead" inTableWithName:tableName]) {
        [self.dataBase executeUpdate:[NSString stringWithFormat:@"alter table '%@' add isRead integer default 0",tableName]];
    }
    return tableName;
}

-(BOOL)isChatTableExist:(NSString*)sessionid {

    if (sessionid.length==0) {
        return NO;
    }
    
    return [self.dataBase tableExists:[self SessionTableName:sessionid]];
}

/*
 群组推送消息表
 字段	类型	约束	备注
 ID	int		自增
 groupId 	Varchar	32	群组id
 type 	int		消息类型
 admin 	Varchar	32	管理员
 member 	Varchar	32	成员
 declared 	Varchar	256	原因
 dateCreated 	Long		服务器的时间 毫秒
 confirm 	int		是否需要确认
 */
- (void)IMGroupNoticeTableCreate {
    [self createTable:@"im_groupnotice" sql:@"CREATE table im_groupnotice(ID INTEGER PRIMARY KEY AUTOINCREMENT,groupId varchar(32),groupName varchar(32),type INTEGER,admin varchar(32),member varchar(32),nickName varchar(32), declared varchar(32), dateCreated INTEGER, isRead INTEGER, confirm INTEGER, sender varchar(32))"];
    if (![self.dataBase columnExists:@"isDiscuss" inTableWithName:@"im_groupnotice"]) {
        [self.dataBase executeUpdate:@"alter table im_groupnotice add isDiscuss integer default 0"];
    }
}

- (void)IMGroupIDTableCreate {
    [self createTable:@"im_groupinfo2" sql:@"CREATE table im_groupinfo2 (groupId TEXT NOT NULL PRIMARY KEY UNIQUE ON CONFLICT REPLACE, type INTEGER, groupname TEXT, isNotice bool); create unique index groupinfo_info_index2 on im_groupinfo2(groupId)"];
    BOOL isExist = [self.dataBase tableExists:@"im_groupinfo"];
    if (isExist) {
        [self.dataBase executeUpdate:@"INSERT INTO im_groupinfo2 SELECT *,YES FROM im_groupinfo"];
        [self.dataBase executeUpdate:@"DROP TABLE IF EXISTS im_groupinfo"];
        [self.dataBase executeUpdate:@"DROP INDEX IF EXISTS groupinfo_info_index"];
    }
}

- (void)IMTriggerCreate {
    
    BOOL result = NO;
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT [sql] FROM sqlite_master WHERE [type] = 'trigger' AND lower(name) = ?", @"delete_obsolete_im"];
    result = [rs next];
    [rs close];
    if (result) {
        [self.dataBase executeUpdate:@"DROP TRIGGER delete_obsolete_im"];
        [self.dataBase executeUpdate:@"DROP TRIGGER im_update_thread_on_insert"];
        [self.dataBase executeUpdate:@"DROP TRIGGER im_update_thread_on_update"];
    }
}

- (void)updateSession:(ECSession*)session{
    
    NSLog(@"self.database=%@",self.dataBase);
    NSLog(@"seesionid=%@, datetime=%@, type=%@, text=%@, unreadcount=%@ isAt=%@ isTop=%@", session.sessionId, @(session.dateTime), @(session.type), session.text, @(session.unreadCount),@(session.isAt),@(session.isTop));
    
    [self.dataBase executeUpdate:@"INSERT INTO session(sessionId, dateTime, type, text, unreadCount, isAt,isTop) VALUES (?,?,?,?,?,?,?)",session.sessionId, @(session.dateTime), @(session.type), session.text, @(session.unreadCount), @(session.isAt),@(session.isTop)];
}

- (void)deleteSession:(NSString*)sessionId{
    [self.dataBase executeUpdate:@"DELETE FROM session WHERE sessionId = ?",sessionId];
}

- (NSMutableDictionary *)loadAllTopSessions:(BOOL)isTop {
    NSMutableDictionary * sessionDictionay = [NSMutableDictionary dictionary];
    
    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT sessionId, dateTime, type, text, unreadCount, sumCount, isAt, isTop FROM session WHERE isTop=%d ORDER BY dateTime DESC",(int)isTop]];
    while ([rs next]) {
        NSString* sessionid = [rs stringForColumnIndex:0];
        if (sessionid.length>0) {
            ECSession* session = [[ECSession alloc] init];
            int columnIndex = 0;
            session.sessionId = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.dateTime = [rs longLongIntForColumnIndex:columnIndex]; columnIndex++;
            session.type = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.text = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.unreadCount = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.sumCount = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.isAt = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.isTop = [rs intForColumnIndex:columnIndex]; columnIndex++;
            [sessionDictionay setObject:session forKey:sessionid];
            [self updateMessageStateFailedAndSessionId:sessionid];
        }
    }
    [rs close];
    
    return sessionDictionay;
}

- (NSMutableDictionary *)loadAllSessions {
    
    NSMutableDictionary * sessionDictionay = [NSMutableDictionary dictionary];
    
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT sessionId, dateTime, type, text, unreadCount, sumCount, isAt, isTop FROM session ORDER BY dateTime DESC"];
    while ([rs next]) {
        NSString* sessionid = [rs stringForColumnIndex:0];
        if (sessionid.length>0) {
            ECSession* session = [[ECSession alloc] init];
            int columnIndex = 0;
            session.sessionId = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.dateTime = [rs longLongIntForColumnIndex:columnIndex]; columnIndex++;
            session.type = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.text = [rs stringForColumnIndex:columnIndex]; columnIndex++;
            session.unreadCount = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.sumCount = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.isAt = [rs intForColumnIndex:columnIndex]; columnIndex++;
            session.isTop = [rs intForColumnIndex:columnIndex]; columnIndex++;
            [sessionDictionay setObject:session forKey:sessionid];
            [self updateMessageStateFailedAndSessionId:sessionid];
        }
    }
    [rs close];
    
    return sessionDictionay;
}

-(NSString*)getDateTime:(long long) data {
    return [NSString stringWithFormat:@"%lld",data];
}

-(BOOL)getGroupFlag:(NSString *)msgid {
    if ([msgid hasPrefix:@"g"]) {
        return YES;
    } else {
        return NO;
    }
}

-(long long)getDateInt:(NSString*) date {
    return [date longLongValue];
}

-(NSString*)getMessageMediaType:(NSString*)displayName {
    
    NSString *http = @"((http[s]{0,1}|ftp)://[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",http];
    BOOL isHttp = [predicate evaluateWithObject:displayName];
    if ([displayName hasSuffix:@".amr"]) {
        return @"[语音]";
    } else if ([displayName hasSuffix:@".jpg"] || [displayName hasSuffix:@".png"]) {
        return @"[图片]";
    } else if ([displayName hasSuffix:@".mp4"]) {
        return @"[视频]";
    } else if (isHttp) {
        return @"[链接]";
    }
    else {
        return @"[文件]";
    }
}

-(int)setValueDic:(NSMutableDictionary *)valueDic andMediaMsgBody:(ECMessageBody*) msgBody andIndex:(int) index {
    
    if ([msgBody isKindOfClass:[ECTextMessageBody class]]) {
        
        [valueDic setObject:@(MessageBodyType_Text) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        ECTextMessageBody * msg = (ECTextMessageBody*) msgBody;
        
        if (msg.text) {
            [valueDic setObject:msg.text forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
    } else if ([msgBody isKindOfClass:[ECFileMessageBody class]]) {
        
        [valueDic setObject:@(msgBody.messageBodyType) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        ECFileMessageBody * msg = (ECFileMessageBody*) msgBody;
        
        NSString *file = @"[文件]";
        if (msg.localPath.length > 0) {
            file = [self getMessageMediaType:msg.localPath];
            
        } else if (msg.remotePath.length > 0) {
            file = [self getMessageMediaType:msg.remotePath];
        }
        
        if (file) {
            [valueDic setObject:file forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        if (msg.localPath) {
            [valueDic setObject:msg.localPath forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        if (msg.remotePath) {
            [valueDic setObject:msg.remotePath forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]];index++;
        
        if ([msgBody isKindOfClass:[ECImageMessageBody class]]) {
                
            ECImageMessageBody * imagemsg = (ECImageMessageBody*) msgBody;
            if (imagemsg.thumbnailRemotePath) {
                [valueDic setObject:imagemsg.thumbnailRemotePath forKey:[NSString stringWithFormat:@"%d", index]];
            }
        } else if ([msgBody isKindOfClass:[ECVideoMessageBody class]]) {
            
            ECVideoMessageBody * videomsg = (ECVideoMessageBody*) msgBody;
            if (videomsg.thumbnailRemotePath) {
                [valueDic setObject:[NSString stringWithFormat:@"%@$$$%lld",videomsg.thumbnailRemotePath, videomsg.fileLength] forKey:[NSString stringWithFormat:@"%d", index]];
            }
        } else if ([msgBody isKindOfClass:[ECPreviewMessageBody class]]) {
            ECPreviewMessageBody *preBody = (ECPreviewMessageBody*)msgBody;
            
            NSDictionary *dict = @{@"url":preBody.url?:@"",@"title":preBody.title?:@"",@"descri":preBody.desc?:@"",@"thumbrp":preBody.thumbnailRemotePath?:@"",@"thumblp":preBody.thumbnailLocalPath?:@""};
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString *remark = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
            [valueDic setObject:remark forKey:[NSString stringWithFormat:@"%d", index]];
        } else {
            if (msg.displayName.length>0) {
                [valueDic setObject:msg.displayName forKey:[NSString stringWithFormat:@"%d", index]];
            }
        }

        index++;
    } else if ([msgBody isKindOfClass:[ECCallMessageBody class]]) {
        
        [valueDic setObject:@(MessageBodyType_Call) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        ECCallMessageBody * msg = (ECCallMessageBody*) msgBody;
        
        if (msg.callText) {
            [valueDic setObject:msg.callText forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@(msg.calltype) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
    } else if ([msgBody isKindOfClass:[ECLocationMessageBody class]]) {
        
        [valueDic setObject:@(MessageBodyType_Location) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        ECLocationMessageBody *msg = (ECLocationMessageBody*) msgBody;
        
        NSDictionary *dict = @{locationLat:@(msg.coordinate.latitude),locationLon:@(msg.coordinate.longitude),locationTitle:msg.title};
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
        NSString *strText = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        [valueDic setObject:strText forKey:[NSString stringWithFormat:@"%d", index]];
        index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
    } else if ([msgBody isKindOfClass:[ECRevokeMessageBody class]]) {
        [valueDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        ECRevokeMessageBody * msg = (ECRevokeMessageBody*) msgBody;
        
        if (msg.text) {
            [valueDic setObject:msg.text forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        [valueDic setObject:@"ECRevokeMessageBody" forKey:[NSString stringWithFormat:@"%d", index]]; index++;

    }
    
    return index;
}

//增加单条消息
-(BOOL)addMessage:(ECMessage*)message
{
    if (message.sessionId.length==0) {
        return NO;
    }
    
    NSString *tableName = [self IMMessageTableCreateWithSession:message.sessionId];
    
    BOOL ret = NO;
    
    NSMutableDictionary *valueDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNull null],@"1",[NSNull null],@"2",[NSNull null],@"3",[NSNull null],@"4",[NSNull null],@"5",[NSNull null],@"6",[NSNull null],@"7",[NSNull null],@"8",[NSNull null],@"9",[NSNull null],@"10",[NSNull null],@"11",[NSNull null],@"12",[NSNull null],@"13", nil];
    int index = 1;
    
    if (message.sessionId) {
        [valueDic setObject:message.sessionId forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    if (message.messageId) {
        [valueDic setObject:message.messageId forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    if (message.from) {
        [valueDic setObject:message.from forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    if (message.to) {
        [valueDic setObject:message.to forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    [valueDic setObject:@([self getDateInt:message.timestamp]) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
    
    if (message.userData) {
        [valueDic setObject:message.userData forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    [valueDic setObject:@(message.messageState) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
    
    int columindex = [self setValueDic:valueDic andMediaMsgBody:message.messageBody andIndex:index];
    [valueDic setObject:@(message.isRead) forKey:[NSString stringWithFormat:@"%d", columindex]];
    
    ret = [self.dataBase executeUpdate:[NSString stringWithFormat:@"INSERT INTO %@(SID, msgid, sender, receiver, createdTime, userData, state, msgType, text, localPath, URL, serverTime, remark,isRead) VALUES (:1 , :2, :3, :4, :5, :6, :7, :8, :9, :10, :11, :12, :13, :14)", tableName] withParameterDictionary:valueDic];
    
    return ret;
}

- (NSString*)getUserName:(NSString*)userId {
    NSString *stringname = nil;
    
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT nickName FROM userName WHERE userid=?", userId];
    if ([rs next]) {
        stringname = [rs stringForColumnIndex:0];
    }
    [rs close];
    
    return stringname;
}

- (ECSexType)getUserSex:(NSString*)userId {
    ECSexType sex = ECSexType_Male;
    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT sex FROM userName WHERE userid=?",userId];
    if ([rs next]) {
        sex = [rs intForColumnIndex:0];
    }
    [rs close];
    return sex;
}

- (void) addUserName:(NSString *)userId name:(NSString*)name andSex:(ECSexType)sex {
    if (userId.length==0 || name.length<=0) {
        return;
    }
    
    [self.dataBase executeUpdate:@"INSERT INTO userName(userid,nickName,sex) VALUES (?,?,?)",userId, name,@(sex)];
}

//删除单条消息
-(BOOL)deleteMessage:(NSString*)msgId andSession:(NSString*)sessionId{
    
    if ([self isChatTableExist:sessionId]) {
        return [self runSql:[NSString stringWithFormat: @"DELETE FROM %@ WHERE msgid = '%@'",[self SessionTableName:sessionId], msgId]];
    }
    return NO;
}

//删除某个会话的所有消息
-(NSInteger)deleteMessageOfSession:(NSString*)sessionId {
    if ([self isChatTableExist:sessionId]) {
        return [self runSql:[NSString stringWithFormat:@"DELETE FROM %@",[self SessionTableName:sessionId]]];
    }
    return 0;
}

- (BOOL)deleteWithTable:(NSString*)table {
    return [self runSql:[NSString stringWithFormat:@"DELETE FROM %@",table]];
}

- (BOOL)deleteAllSession {
    return [self deleteWithTable:@"session"];
}

- (BOOL)deleteAllGroupNotice {
    return [self deleteWithTable:@"im_groupnotice"];
}

- (BOOL)runSql:(NSString*)sql {
    return [self.dataBase executeUpdate:sql];
}

- (int)getCountWithSql:(NSString*)sql {
    
    int count = 0;
    FMResultSet *rs = [self.dataBase executeQuery:sql];
    if ([rs next]) {
        count = [rs intForColumnIndex:0];
    }
    [rs close];
    return count;
}

-(NSInteger)getUnreadMessageCountFromSession {
    return [self getCountWithSql:[NSString stringWithFormat:@"SELECT sum(unreadCount) FROM session"]];
}

- (NSArray *)getAllMessageOfSessionId:(NSString *)sessionId
{
    NSString *tableName = [self IMMessageTableCreateWithSession:sessionId];
    
    NSMutableArray *msgArray = [[NSMutableArray alloc] init];

    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT  SID, msgid, sender, receiver, createdTime, userData, state, msgType, text, localPath, URL, serverTime, remark, isRead FROM (SELECT * FROM %@ ORDER BY createdTime) ORDER BY createdTime ASC",tableName]];
    
    while ([rs next]) {
        ECMessage *msg = [[ECMessage alloc] init];
        int columnIndex = 0;
        msg.sessionId = [rs stringForColumnIndex:columnIndex];columnIndex++;
        msg.isGroup = [self getGroupFlag:msg.sessionId];
        msg.messageId = [rs stringForColumnIndex:columnIndex];columnIndex++;
        msg.from = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.to = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.timestamp = [self getDateTime:[rs longLongIntForColumnIndex:columnIndex]]; columnIndex++;
        msg.userData = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.messageState = [rs intForColumnIndex:columnIndex];columnIndex++;
        MessageBodyType msgType = [rs intForColumnIndex:columnIndex];columnIndex++;
        msg.messageBody = (ECMessageBody*)[self getMessageBodyWithResultSet:rs andType:msgType];
        msg.isRead = [rs intForColumnIndex:14];
        [msgArray addObject:msg];
    }
    [rs close];
    return msgArray;
}

-(ECMessage*)getMessagesWithMessageId:(NSString*)messageId  OfSession:(NSString *)sessionId {
    NSArray *array = [self getSomeMessagesCount:1 andConditions:[NSString stringWithFormat:@"msgid='%@'",messageId] OfSession:sessionId];
    if (array.count>0) {
        return array[0];
    }
    return nil;
}
-(NSArray*)getSomeMessagesCount:(NSInteger)count andConditions:(NSString*) conditions  OfSession:(NSString *)sessionId {
    
    NSString *tableName = [self IMMessageTableCreateWithSession:sessionId];
    
    NSMutableArray * msgArray = [NSMutableArray array];
    
    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT msgid, sender, receiver, createdTime , userData , SID, state, msgType, text, localPath, URL, serverTime, dstate, remark, isRead FROM (SELECT * FROM %@ WHERE %@  ORDER BY createdTime DESC LIMIT %d) ORDER BY createdTime ASC", tableName, conditions, (int)count]];
    while ([rs next]) {
        ECMessage* msg = [[ECMessage alloc] init];
        int columnIndex = 0;
        msg.messageId = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.from = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.to = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.timestamp = [self getDateTime:[rs longLongIntForColumnIndex:columnIndex]]; columnIndex++;
        msg.userData = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.sessionId = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.isGroup = [self getGroupFlag:msg.sessionId];
        msg.messageState = [rs intForColumnIndex:columnIndex];columnIndex++;
        MessageBodyType msgType = [rs intForColumnIndex:columnIndex];columnIndex++;
        msg.messageBody = (ECMessageBody*)[self getMessageBodyWithResultSet:rs andType:msgType];
        msg.isRead = [rs intForColumnIndex:14];
        [msgArray addObject:msg];
    }
    [rs close];
    return msgArray;
}

- (NSArray *)getAllLocalPathMessageOfSessionId:(NSString *)sessionId type:(MessageBodyType)messageBodyType
{
    NSArray *messageArray = [self getAllMessageOfSessionId:sessionId];
    
    NSMutableArray *imageArray = [NSMutableArray array];
    ECFileMessageBody *mediaBody = [[ECFileMessageBody alloc] init];
    for (ECMessage *msg in messageArray) {
        if (msg.messageBody.messageBodyType == messageBodyType) {
            mediaBody = (ECFileMessageBody*)msg.messageBody;
            if (mediaBody) {
                [imageArray addObject:mediaBody];
            }
        }
    }
    return imageArray;
}
//获取会话的某个时间点之前的count条消息
-(NSArray*)getSomeMessagesCount:(NSInteger)count OfSession:(NSString*)sessionId beforeTime:(long long)timesamp {
    return [self getSomeMessagesCount:count andConditions:[NSString stringWithFormat:@"createdTime < %lld ",timesamp] OfSession:sessionId];
}

-(NSArray*)getLatestSomeMessagesCount:(NSInteger)count OfSession:(NSString *)sessionId {
    
    NSString *tableName = [self IMMessageTableCreateWithSession:sessionId];
    
    NSMutableArray * msgArray = [NSMutableArray array];
    
    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT msgid, sender, receiver, createdTime , userData , SID, state, msgType, text, localPath, URL, serverTime, dstate, remark,isRead FROM (SELECT * FROM %@ ORDER BY createdTime DESC LIMIT %d) ORDER BY createdTime ASC", tableName, (int)count]];
    while ([rs next]) {
        ECMessage* msg = [[ECMessage alloc] init];
        int columnIndex = 0;
        msg.messageId = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.from = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.to = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.timestamp = [self getDateTime:[rs longLongIntForColumnIndex:columnIndex]]; columnIndex++;
        msg.userData = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.sessionId = [rs stringForColumnIndex:columnIndex]; columnIndex++;
        msg.isGroup = [self getGroupFlag:msg.sessionId];
        msg.messageState = [rs intForColumnIndex:columnIndex];columnIndex++;
        MessageBodyType msgType = [rs intForColumnIndex:columnIndex];columnIndex++;
        msg.messageBody = (ECMessageBody*)[self getMessageBodyWithResultSet:rs andType:msgType];
        msg.isRead = [rs intForColumnIndex:14];
        [msgArray addObject:msg];
    }
    [rs close];
    return msgArray;
}

//获取会话的某个时间点之后的count条消息
-(NSArray*)getSomeMessagesCount:(NSInteger)count OfSession:(NSString*)sessionId afterTime:(long long)timesamp {
    return [self getSomeMessagesCount:count andConditions:[NSString stringWithFormat:@"createdTime >= %lld ",timesamp] OfSession:sessionId];
}


-(id)getMessageBodyWithResultSet:(FMResultSet*)rs andType:(MessageBodyType)type {
    
    switch (type) {
        case MessageBodyType_None: {
            NSString *remark = [rs stringForColumnIndex:13];
            if ([remark isEqualToString:@"ECRevokeMessageBody"]) {
                ECRevokeMessageBody *messageBody = [[ECRevokeMessageBody alloc] initWithText:[rs stringForColumnIndex:8]];
                return messageBody;
            }
            return nil;
        }
            
        case MessageBodyType_Text: {
            ECTextMessageBody* messageBody = [[ECTextMessageBody alloc] initWithText:[rs stringForColumnIndex:8]];
            return messageBody;
        }
            
        case MessageBodyType_File: {
            ECFileMessageBody * messageBody = [[ECFileMessageBody alloc] initWithFile:[rs stringForColumnIndex:9] displayName:@""];
            messageBody.remotePath = [rs stringForColumnIndex:10];
            messageBody.mediaDownloadStatus = [rs intForColumnIndex:12];
            messageBody.displayName = [rs stringForColumnIndex:13];
            return messageBody;
        }
            
        case MessageBodyType_Image: {
            ECImageMessageBody * messageBody = [[ECImageMessageBody alloc] initWithFile:[rs stringForColumnIndex:9] displayName:@""];
            messageBody.remotePath = [rs stringForColumnIndex:10];
            messageBody.mediaDownloadStatus = [rs intForColumnIndex:12];
            messageBody.thumbnailRemotePath = [rs stringForColumnIndex:13];
            return messageBody;
        }
            
        case MessageBodyType_Video: {
            ECVideoMessageBody * messageBody = [[ECVideoMessageBody alloc] initWithFile:[rs stringForColumnIndex:9] displayName:@""];
            messageBody.remotePath = [rs stringForColumnIndex:10];
            messageBody.mediaDownloadStatus = [rs intForColumnIndex:12];
            NSString *remark = [rs stringForColumnIndex:13];
            if (remark.length>0) {
                NSArray *array = [remark componentsSeparatedByString:@"$$$"];
                if (array.count==2) {
                    messageBody.thumbnailRemotePath = array[0];
                    messageBody.fileLength = [array[1] longLongValue];
                } else {
                    messageBody.thumbnailRemotePath = remark;
                }
            }
            return messageBody;
        }
            
        case MessageBodyType_Voice: {
            ECVoiceMessageBody * messageBody = [[ECVoiceMessageBody alloc] initWithFile:[rs stringForColumnIndex:9] displayName:@""];
            messageBody.remotePath = [rs stringForColumnIndex:10];
            messageBody.mediaDownloadStatus = [rs intForColumnIndex:12];
            messageBody.displayName = [rs stringForColumnIndex:13];
            return messageBody;
        }
            
        case MessageBodyType_Call: {
            ECCallMessageBody* messageBody = [[ECCallMessageBody alloc] initWithCallText:[rs stringForColumnIndex:8]];
            messageBody.calltype = (CallType)[[rs stringForColumnIndex:13] integerValue];
            return messageBody;
        }
                    
        case MessageBodyType_Location: {
            ECLocationMessageBody* messageBody = [[ECLocationMessageBody alloc] init];
            NSString *text = [rs stringForColumnIndex:8];
            
            NSData* data = [text dataUsingEncoding:NSUTF8StringEncoding];
            NSError *error;
            NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data
                                                                       options:NSJSONReadingMutableLeaves
                                                                         error:&error];
            if (jsonObject) {
                messageBody.title = [jsonObject objectForKey:locationTitle];
                double latitude = [[jsonObject objectForKey:locationLat] doubleValue];
                double longitude = [[jsonObject objectForKey:locationLon] doubleValue];
                CLLocationCoordinate2D coordinate;
                coordinate.latitude = latitude;
                coordinate.longitude = longitude;
                messageBody.coordinate = coordinate;

                return messageBody;
            }
        }
        case MessageBodyType_Preview: {
            ECPreviewMessageBody *preBody = [[ECPreviewMessageBody alloc] init];
            preBody.localPath = [rs stringForColumnIndex:9];
            preBody.remotePath = [rs stringForColumnIndex:10];
            preBody.serverTime = [rs stringForColumnIndex:11];
            preBody.mediaDownloadStatus = [rs intForColumnIndex:12];
            NSString *remark = [rs stringForColumnIndex:13];
            if (remark) {
                NSData* data = [remark dataUsingEncoding:NSUTF8StringEncoding]?:nil;
                NSError *error;
                NSDictionary* jsonObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
                if (!jsonObject) {
                    return preBody;
                }
                preBody.title = [jsonObject objectForKey:@"title"];
                preBody.desc = [jsonObject objectForKey:@"descri"];
                preBody.url = [jsonObject objectForKey:@"url"];
                preBody.thumbnailLocalPath = [jsonObject objectForKey:@"thumblp"];
                preBody.thumbnailRemotePath = [jsonObject objectForKey:@"thumbrp"];
                return preBody;
            }
            return preBody;
        }
            
        default:
            return nil;
    }
}

//修改单条消息的下载路径
-(BOOL)updateMessageLocalPath:(NSString*)msgId withPath:(NSString*)path withDownloadState:(ECMediaDownloadStatus)state andSession:(NSString*)sessionId{
    if ([self isChatTableExist:sessionId]) {
    return [self runSql:[NSString stringWithFormat:@"UPDATE %@ SET localPath='%@',dstate = %d WHERE msgid = '%@' ",[self SessionTableName:sessionId],path,(int)state, msgId]];
    }
    return NO;
}

//修改单条视频消息的缩略图下载路径
-(BOOL)updateMessageThumbnailLocalPath:(NSString*)msgId withPath:(NSString*)path withDownloadState:(ECMediaDownloadStatus)state andSession:(NSString*)sessionId{
    if ([self isChatTableExist:sessionId]) {
        return [self runSql:[NSString stringWithFormat:@"UPDATE %@ SET localPath='%@',dstate = %d WHERE msgid = '%@' ",[self SessionTableName:sessionId],path,(int)state, msgId]];
    }
    return NO;
}

//更新某消息的状态
-(BOOL)updateState:(ECMessageState)state ofMessageId:(NSString*)msgId andSession:(NSString*)sessionId {
    if ([self isChatTableExist:sessionId]) {
    return [self runSql:[NSString stringWithFormat:@"UPDATE %@ SET state = %d WHERE msgid = '%@' ",[self SessionTableName:sessionId],(int)state, msgId]];
    }
    return NO;
}

//重发，更新某消息的消息id
-(BOOL)updateMessageId:(NSString*)msdNewId andTime:(long long)time ofMessageId:(NSString*)msgOldId andSession:(NSString*)sessionId {
    if ([self isChatTableExist:sessionId]) {
    return [self runSql:[NSString stringWithFormat:@"UPDATE %@ SET msgid='%@', createdTime=%lld WHERE msgid='%@' ", [self SessionTableName:sessionId], msdNewId, time, msgOldId]];
    }
    return NO;
}

-(BOOL)updateMessageStateFailedAndSessionId:(NSString*)sessionId {
    if ([self isChatTableExist:sessionId]) {
    return [self runSql:[NSString stringWithFormat:@"UPDATE %@ SET state=%d WHERE state=%d ", [self SessionTableName:sessionId],(int)ECMessageState_SendFail, (int)ECMessageState_Sending]];
    }
    return NO;
}

- (BOOL)updateMessage:(NSString*)sessionId msgid:(NSString*)msgId withMessage:(ECMessage*)message {
    if ([self isChatTableExist:sessionId] && [message.messageBody isKindOfClass:[ECRevokeMessageBody class]]) {
        ECRevokeMessageBody *revokeBody = (ECRevokeMessageBody*)message.messageBody;
        NSString *sql = [NSString stringWithFormat:@"UPDATE %@ SET state=%d, msgType=%d, text='%@', remark='%@' WHERE msgid='%@' ",[self SessionTableName:sessionId],(int)message.messageState,(int)message.messageBody.messageBodyType,revokeBody.text,@"ECRevokeMessageBody",msgId];
        return [self runSql:sql];
    }
    return NO;
}

-(BOOL)updateNoTop {
    return [self runSql:[NSString stringWithFormat:@"UPDATE session SET isTop=0"]];
}

-(BOOL)updateIsTopSessionId:(NSString*)sessionId isTop:(BOOL)isTop {
    return [self runSql:[NSString stringWithFormat:@"UPDATE session SET isTop=%d WHERE sessionid='%@' ",(int)isTop, sessionId]];
}

-(BOOL)updateMessageReadState:(ECMessage*)message {
    if ([self isChatTableExist:message.sessionId]) {
        return [self runSql:[NSString stringWithFormat:@"UPDATE %@ SET isRead=%d WHERE msgid='%@' ", [self SessionTableName:message.sessionId],(int)message.isRead, message.messageId]];
    }
    return NO;
}
-(BOOL)updateMessageReadState:(NSString*)sessionId messageId:(NSString*)messageId isRead:(BOOL)isRead {
    if ([self isChatTableExist:sessionId]) {
        return [self runSql:[NSString stringWithFormat:@"UPDATE %@ SET isRead=%d WHERE msgid='%@' ", [self SessionTableName:sessionId],(int)isRead, messageId]];
    }
    return NO;
}
#pragma mark 群组消息操作API

-(int)setValueDic:(NSMutableDictionary *) valueDic andGroupMsg:(ECGroupNoticeMessage*) message andIndex:(int) index {
    
    if (message.messageType == ECGroupMessageType_Invite) {
        
        ECInviterMsg * msg = (ECInviterMsg*) message;
        if (msg.admin) {
            [valueDic setObject:msg.admin forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.declared) {
            [valueDic setObject:msg.declared forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@(msg.confirm) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.nickName) {
            [valueDic setObject:msg.nickName forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
    } else if (message.messageType == ECGroupMessageType_Propose) {
        
        ECProposerMsg * msg = (ECProposerMsg*) message;
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.proposer) {
            [valueDic setObject:msg.proposer forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        if (msg.declared) {
            [valueDic setObject:msg.declared forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@(msg.confirm) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.nickName) {
            [valueDic setObject:msg.nickName forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
    } else if (message.messageType == ECGroupMessageType_Join) {
        
        ECJoinGroupMsg * msg = (ECJoinGroupMsg*) message;
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.member) {
            [valueDic setObject:msg.member forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        if (msg.declared) {
            [valueDic setObject:msg.declared forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.nickName) {
            [valueDic setObject:msg.nickName forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
    } else if (message.messageType == ECGroupMessageType_Quit) {
        
        ECQuitGroupMsg * msg = (ECQuitGroupMsg*) message;
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.member) {
            [valueDic setObject:msg.member forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        [valueDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.nickName) {
            [valueDic setObject:msg.nickName forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
    } else if (message.messageType == ECGroupMessageType_RemoveMember) {
        
        ECRemoveMemberMsg * msg = (ECRemoveMemberMsg*) message;
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.member) {
            [valueDic setObject:msg.member forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        [valueDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.nickName) {
            [valueDic setObject:msg.nickName forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
    } else if (message.messageType == ECGroupMessageType_ReplyInvite) {
        
        ECReplyJoinGroupMsg * msg = (ECReplyJoinGroupMsg*) message;
        
        if (msg.admin) {
            [valueDic setObject:msg.admin forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        if (msg.member) {
            [valueDic setObject:msg.member forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        [valueDic setObject:@(msg.confirm) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.nickName) {
            [valueDic setObject:msg.nickName forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
    } else if (message.messageType == ECGroupMessageType_ReplyJoin) {
        
        ECReplyJoinGroupMsg * msg = (ECReplyJoinGroupMsg*) message;
        
        if (msg.admin) {
            [valueDic setObject:msg.admin forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        if (msg.member) {
            [valueDic setObject:msg.member forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        [valueDic setObject:@(msg.confirm) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.nickName) {
            [valueDic setObject:msg.nickName forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
    } else if (message.messageType == ECGroupMessageType_ModifyGroup) {
        
        ECModifyGroupMsg *msg = (ECModifyGroupMsg*) message;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        if (msg.member) {
            [valueDic setObject:msg.member forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        if (msg.modifyDic) { //declared
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msg.modifyDic options:NSJSONWritingPrettyPrinted error:&error];
            if (!jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [valueDic setObject:jsonString forKey:[NSString stringWithFormat:@"%d", index]];
            }
        }index++;

        [valueDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d", index]]; index++;

        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
    } else if (message.messageType == ECGroupMessageType_ChangeAdmin) {
        ECChangeAdminMsg *msg = (ECChangeAdminMsg*) message;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.member) {
            [valueDic setObject:msg.member forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        [valueDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.nickName) {
            [valueDic setObject:msg.nickName forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
    } else if (message.messageType == ECGroupMessageType_Dissmiss) {
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        [valueDic setObject:@"" forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
    } else if (message.messageType ==ECGroupMessageType_ChangeMemberRole) {
        ECChangeMemberRoleMsg *msg = (ECChangeMemberRoleMsg*) message;
        
        [valueDic setObject:msg.sender forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.member) {
            [valueDic setObject:msg.member forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
        
        if (msg.roleDic) { //declared
            NSError *error;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:msg.roleDic options:NSJSONWritingPrettyPrinted error:&error];
            if (!jsonData) {
                NSLog(@"Got an error: %@", error);
            } else {
                NSString * jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [valueDic setObject:jsonString forKey:[NSString stringWithFormat:@"%d", index]];
            }
        }index++;
        
        [valueDic setObject:@(0) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
        
        if (msg.nickName) {
            [valueDic setObject:msg.nickName forKey:[NSString stringWithFormat:@"%d", index]];
        }index++;
    }
    
    return index;
}

//增加一条消息
-(BOOL)addGroupMessage:(ECGroupNoticeMessage*)message {
    BOOL ret = NO;
    
    NSMutableDictionary *valueDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:[NSNull null],@"1",[NSNull null],@"2",[NSNull null],@"3",[NSNull null],@"4",[NSNull null],@"5",[NSNull null],@"6",[NSNull null],@"7",[NSNull null],@"8",[NSNull null],@"9",[NSNull null],@"10",[NSNull null],@"11",[NSNull null],@"12", nil];
    int index = 1;
    if (message.groupId) {
        [valueDic setObject:message.groupId forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    [valueDic setObject:@(message.messageType) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
    [valueDic setObject:@([self getDateInt:message.dateCreated]) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
    [valueDic setObject:@(message.isRead) forKey:[NSString stringWithFormat:@"%d", index]]; index++;
    
    if (message.sender) {
        [valueDic setObject:message.sender forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    if (message.groupName) {
        [valueDic setObject:message.groupName forKey:[NSString stringWithFormat:@"%d", index]];
    }index++;
    
    index = [self setValueDic:valueDic andGroupMsg:message andIndex:index];
    
    [valueDic setObject:@(message.isDiscuss) forKey:[NSString stringWithFormat:@"%d", index]];index++;
    
    ret = [self.dataBase executeUpdate:@"INSERT INTO im_groupnotice(groupId,type,dateCreated,isRead,sender,groupName,admin,member,declared,confirm,nickName,isDiscuss) VALUES (:1,:2,:3,:4,:5,:6,:7,:8,:9,:10,:11,:12)" withParameterDictionary:valueDic];
    
    return ret;
}

//增加一条消息
-(BOOL)addGroupID:(ECGroup*)group {
    return [self.dataBase executeUpdate:@"INSERT INTO im_groupinfo2(groupId,groupname,isNotice,type) VALUES (?,?,?,?)",group.groupId, group.name,@(group.isNotice),@(group.isDiscuss)];
}

//增加多条群通知消息
-(NSInteger)addGroupMessages:(NSArray*)messages {
    int i = 0;
    for (ECGroupNoticeMessage* groupMsg in messages) {
        if ([self addGroupMessage:groupMsg]) {
            i++;
        }
    }
    return i;
}

//增加多条消息
-(NSInteger)addGroupIDs:(NSArray*)messages {
    
    int i = 0;
    for (ECGroup* groupMsg in messages) {
        if ([self addGroupID:groupMsg]) {
            i++;
        }
    }
    return i;
}

-(NSString *)getGroupNameOfId:(NSString *)groupId {
    NSString *groupName = nil;

    FMResultSet *rs = [self.dataBase executeQuery:@"SELECT groupname FROM im_groupinfo2 WHERE groupId=?", groupId];
    if ([rs next]) {
        groupName = [rs stringForColumnIndex:0];
    }
    [rs close];

    return groupName;
}

-(BOOL)isDiscussOfGroupId:(NSString *)groupId {
    BOOL isDiscuss;
    
    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT type FROM im_groupinfo2 WHERE groupId='%@'", groupId]];
    if ([rs next]) {
        isDiscuss = [rs boolForColumnIndex:0];
    }
    [rs close];
    
    return isDiscuss;
}

-(BOOL)isNoticeOfGroupId:(NSString *)groupId {
    
    BOOL isNotice = YES;
    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT isNotice FROM im_groupinfo2 WHERE groupId='%@'", groupId]];
    if ([rs next]) {
        isNotice = [rs boolForColumnIndex:0];
    }
    [rs close];
    
    return isNotice;
}

-(void)setIsNotice:(BOOL)isNotice ofGroupId:(NSString *)groupId {
    [self.dataBase executeUpdate:@"UPDATE im_groupinfo2 SET isNotice=? WHERE groupId=?", @(isNotice), groupId];
}
//删除关于某群组的所有消息
-(NSInteger)deleteGroupMessagesOfGroup:(NSString*)groupId {
    return [self runSql:[NSString stringWithFormat:@"DELETE FROM im_groupnotice WHERE groupId = '%@'",groupId]];
}

//清空表
-(NSInteger)clearGroupMessageTable {
    return [self deleteAllGroupNotice];
}

//获取表中所有未读消息数
-(NSInteger)getUnreadGroupMessageCount {
    return [self getCountWithSql:[NSString stringWithFormat:@"SELECT count(*) FROM im_groupnotice WHERE isRead = 0"]];
}

//获取确定群组的未读消息数
-(NSInteger)getUnreadGroupMessageCountOfGroup:(NSString*)groupId {
    return [self getCountWithSql:[NSString stringWithFormat:@"SELECT count(*) FROM im_groupnotice WHERE isRead = 0 AND groupId = '%@'",groupId]];
}

//获取表中消息数
-(NSInteger)getAllGroupMessageCount {
    return [self getCountWithSql:[NSString stringWithFormat:@"SELECT count(*) FROM im_groupnotice"]];
}

//获取表中确定群组消息数
-(NSInteger)getAllGroupMessageCountOfGroup:(NSString*)groupId {
    return [self getCountWithSql:[NSString stringWithFormat:@"SELECT count(*) FROM im_groupnotice WHERE groupId = '%@'",groupId]];
}

//获取群组中某个时间点之前的count条数据
-(NSArray*)getSomeGroupMessagesCount:(NSInteger)count OfGroup:(NSString*)group beforeTime:(long long)timesamp {
    NSMutableArray* groupMsgArr = [NSMutableArray array];
    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT groupId, type, dateCreated, isRead, admin, member, declared, confirm, sender, groupName, nickName, isDiscuss FROM im_groupnotice WHERE groupId = '%@' AND dateCreated <= %lld ORDER BY ID DESC LIMIT %d",group,timesamp,(int)count]];
    while ([rs next]) {
        id msg = [self getGroupMsgWithResultSet:rs];
        if (msg) {
            [groupMsgArr addObject:msg];
        }
    }
    [rs close];
    return groupMsgArr;
}

- (NSArray *)getGroupSessionArray {
    NSMutableArray* groupMsgArr = [NSMutableArray array];
    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT groupId,type,max(dateCreated),isRead,admin,member,declared,confirm,sender,groupName,nickName,isDiscuss FROM im_groupnotice group  by sender ORDER BY dateCreated DESC"]];
    while ([rs next]) {
        id msg = [self getGroupMsgWithResultSet:rs];
        if (msg) {
            [groupMsgArr addObject:msg];
        }
    }
    [rs close];
    return groupMsgArr;
}

//获取群组中的count条数据
-(NSArray*)getSomeGroupMessagesCount:(NSInteger)count {
    NSMutableArray* groupMsgArr = [NSMutableArray array];
    FMResultSet *rs = [self.dataBase executeQuery:[NSString stringWithFormat:@"SELECT groupId,type,dateCreated,isRead,admin,member,declared,confirm,sender,groupName,nickName,isDiscuss FROM im_groupnotice ORDER BY dateCreated DESC LIMIT %d",(int)count]];
    while ([rs next]) {
        id msg = [self getGroupMsgWithResultSet:rs];
        if (msg) {
            [groupMsgArr addObject:msg];
        }
    }
    [rs close];
    return groupMsgArr;
}

-(id)getGroupMsgWithResultSet:(FMResultSet*)rs {
    
    int messageType = [rs intForColumnIndex:1];
    if (messageType == ECGroupMessageType_Dissmiss) {
        
        ECDismissGroupMsg * msg = [[ECDismissGroupMsg alloc] init];
        msg.groupId = [rs stringForColumnIndex:0];
        msg.dateCreated = [rs stringForColumnIndex:2];
        msg.isRead = [rs intForColumnIndex:3];
        msg.sender = [rs stringForColumnIndex:8];
        msg.groupName = [rs stringForColumnIndex:9];
        msg.isDiscuss = [rs intForColumnIndex:11];
        return msg;
        
    } else if (messageType == ECGroupMessageType_Invite) {
        
        ECInviterMsg * msg = [[ECInviterMsg alloc] init];
        msg.groupId = [rs stringForColumnIndex:0];
        msg.dateCreated = [rs stringForColumnIndex:2];
        msg.isRead = [rs intForColumnIndex:3];
        msg.admin = [rs stringForColumnIndex:4];
        msg.declared = [rs stringForColumnIndex:6];
        msg.confirm = [rs intForColumnIndex:7];
        msg.sender = [rs stringForColumnIndex:8];
        msg.groupName = [rs stringForColumnIndex:9];
        msg.nickName = [rs stringForColumnIndex:10];
        msg.isDiscuss = [rs intForColumnIndex:11];
        return msg;
        
    } else if (messageType == ECGroupMessageType_Propose) {
        
        ECProposerMsg * msg = [[ECProposerMsg alloc] init];
        msg.groupId = [rs stringForColumnIndex:0];
        msg.dateCreated = [rs stringForColumnIndex:2];
        msg.isRead = [rs intForColumnIndex:3];
        msg.proposer = [rs stringForColumnIndex:5];
        msg.declared = [rs stringForColumnIndex:6];
        msg.confirm = [rs intForColumnIndex:7];
        msg.sender = [rs stringForColumnIndex:8];
        msg.groupName = [rs stringForColumnIndex:9];
        msg.nickName = [rs stringForColumnIndex:10];
        msg.isDiscuss = [rs intForColumnIndex:11];
        return msg;
        
    } else if (messageType == ECGroupMessageType_Join) {
        
        ECJoinGroupMsg * msg = [[ECJoinGroupMsg alloc] init];
        msg.groupId = [rs stringForColumnIndex:0];
        msg.dateCreated = [rs stringForColumnIndex:2];
        msg.isRead = [rs intForColumnIndex:3];
        msg.member = [rs stringForColumnIndex:5];
        msg.declared = [rs stringForColumnIndex:6];
        msg.sender = [rs stringForColumnIndex:8];
        msg.groupName = [rs stringForColumnIndex:9];
        msg.nickName = [rs stringForColumnIndex:10];
        msg.isDiscuss = [rs intForColumnIndex:11];
        return msg;
        
    } else if (messageType == ECGroupMessageType_Quit) {
        
        ECQuitGroupMsg * msg = [[ECQuitGroupMsg alloc] init];
        msg.groupId = [rs stringForColumnIndex:0];
        msg.dateCreated = [rs stringForColumnIndex:2];
        msg.isRead = [rs intForColumnIndex:3];
        msg.member = [rs stringForColumnIndex:5];
        msg.sender = [rs stringForColumnIndex:8];
        msg.groupName = [rs stringForColumnIndex:9];
        msg.nickName = [rs stringForColumnIndex:10];
        msg.isDiscuss = [rs intForColumnIndex:11];
        return msg;
        
    } else if (messageType == ECGroupMessageType_RemoveMember) {
        
        ECRemoveMemberMsg * msg = [[ECRemoveMemberMsg alloc] init];
        msg.groupId = [rs stringForColumnIndex:0];
        msg.dateCreated = [rs stringForColumnIndex:2];
        msg.isRead = [rs intForColumnIndex:3];
        msg.member = [rs stringForColumnIndex:5];
        msg.sender = [rs stringForColumnIndex:8];
        msg.groupName = [rs stringForColumnIndex:9];
        msg.nickName = [rs stringForColumnIndex:10];
        msg.isDiscuss = [rs intForColumnIndex:11];
        return msg;
        
    } else if (messageType == ECGroupMessageType_ReplyInvite) {
        
        ECReplyInviteGroupMsg * msg = [[ECReplyInviteGroupMsg alloc] init];
        msg.groupId = [rs stringForColumnIndex:0];
        msg.dateCreated = [rs stringForColumnIndex:2];
        msg.isRead = [rs intForColumnIndex:3];
        msg.admin = [rs stringForColumnIndex:4];
        msg.member = [rs stringForColumnIndex:5];
        msg.confirm = [rs intForColumnIndex:7];
        msg.sender = [rs stringForColumnIndex:8];
        msg.groupName = [rs stringForColumnIndex:9];
        msg.nickName = [rs stringForColumnIndex:10];
        msg.isDiscuss = [rs intForColumnIndex:11];
        return msg;
        
    } else if (messageType == ECGroupMessageType_ReplyJoin) {
        
        ECReplyJoinGroupMsg * msg = [[ECReplyJoinGroupMsg alloc] init];
        msg.groupId = [rs stringForColumnIndex:0];
        msg.dateCreated = [rs stringForColumnIndex:2];
        msg.isRead = [rs intForColumnIndex:3];
        msg.admin = [rs stringForColumnIndex:4];
        msg.member = [rs stringForColumnIndex:5];
        msg.confirm = [rs intForColumnIndex:7];
        msg.sender = [rs stringForColumnIndex:8];
        msg.groupName = [rs stringForColumnIndex:9];
        msg.nickName = [rs stringForColumnIndex:10];
        msg.isDiscuss = [rs intForColumnIndex:11];
        return msg;
    } else if (messageType == ECGroupMessageType_ModifyGroup) {
        ECModifyGroupMsg * msg = [[ECModifyGroupMsg alloc] init];
        msg.groupId = [rs stringForColumnIndex:0];
        msg.dateCreated = [rs stringForColumnIndex:2];
        msg.isRead = [rs intForColumnIndex:3];
        msg.member = [rs stringForColumnIndex:5];
        msg.sender = [rs stringForColumnIndex:8];
        msg.groupName = [rs stringForColumnIndex:9];
        msg.isDiscuss = [rs intForColumnIndex:11];
        
        NSString *jsonstring = [rs stringForColumnIndex:6];
        msg.modifyDic = nil;
        if (jsonstring.length>0) {
            NSError* extError;
            NSData * jsondata = [jsonstring dataUsingEncoding:NSUTF8StringEncoding];
            msg.modifyDic = [NSJSONSerialization JSONObjectWithData:jsondata
                                                            options:0
                                                              error:&extError];
        }
        return msg;
    } else if (messageType == ECGroupMessageType_ChangeAdmin) {
        ECChangeAdminMsg *msg = [[ECChangeAdminMsg alloc] init];
        msg.groupId = [rs stringForColumnIndex:0];
        msg.dateCreated = [rs stringForColumnIndex:2];
        msg.member = [rs stringForColumnIndex:5];
        msg.groupName = [rs stringForColumnIndex:9];
        msg.nickName = [rs stringForColumnIndex:10];
        msg.isDiscuss = [rs intForColumnIndex:11];
        return msg;
    } else if (messageType == ECGroupMessageType_ChangeMemberRole) {
        ECChangeMemberRoleMsg *msg = [[ECChangeMemberRoleMsg alloc] init];
        msg.groupId = [rs stringForColumnIndex:0];
        msg.dateCreated = [rs stringForColumnIndex:2];
        msg.member = [rs stringForColumnIndex:5];
        msg.groupName = [rs stringForColumnIndex:9];
        msg.nickName = [rs stringForColumnIndex:10];
        msg.isDiscuss = [rs intForColumnIndex:11];
        msg.sender = [rs stringForColumnIndex:8];
        
        NSString *jsonstring = [rs stringForColumnIndex:6];
        msg.roleDic = nil;
        if (jsonstring.length>0) {
            NSError* extError;
            NSData * jsondata = [jsonstring dataUsingEncoding:NSUTF8StringEncoding];
            msg.roleDic = [NSJSONSerialization JSONObjectWithData:jsondata
                                                            options:0
                                                              error:&extError];
        }
        return msg;
    }
    return nil;
}

//标记某群组中所有消息已读
-(NSInteger)markGroupMessagesAsReadOfGroup:(NSString*)groupId {
    return [self runSql:[NSString stringWithFormat:@"UPDATE im_groupnotice SET isRead = 1 WHERE groupId = '%@' AND isRead=0", groupId]];
}

//标记某群组中所有消息已处理
-(NSInteger)markGroupMessagesAsDownOfGroup:(NSString*)groupId andMemberId:(NSString*)member {
    return [self runSql:[NSString stringWithFormat:@"UPDATE im_groupnotice SET confirm=2 WHERE groupId = '%@' AND member='%@'", groupId,member]];
}

-(NSInteger)markGroupMessagesAsDownOfGroup:(NSString*)groupId andAdminId:(NSString*)admin {
    return [self runSql:[NSString stringWithFormat:@"UPDATE im_groupnotice SET confirm=2 WHERE groupId = '%@' AND admin='%@'", groupId, admin]];
}

//标记表中所有消息已读
-(NSInteger)markGroupMessagesAsRead {
    return [self runSql:[NSString stringWithFormat:@"UPDATE im_groupnotice SET isRead = 1"]];
}

@end
