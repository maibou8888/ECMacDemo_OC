//
//  DeviceDBHelper.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/15.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECGroupNoticeMessage.h"
#import "IMMsgDBAccess.h"

#define KNotification_DeleteLocalSessionMessage @"KNotification_DeleteLocalSessionMessage"

@interface DeviceDBHelper : NSObject
@property(nonatomic, strong) NSMutableArray* joinGroupArray;
@property(nonatomic, strong) NSMutableDictionary *sessionDic;
@property(nonatomic, strong) NSMutableArray* joinDiscussArray;
@property(nonatomic, strong) NSMutableArray *topContactLists;

//获取句柄
+(DeviceDBHelper*)sharedInstance;

//获取某个会话的所有消息
- (NSArray *)getAllMessagesOfSessionId:(NSString*)sessionId;

//获取某个会话的所有内容,并且消息类型为type的消息
- (NSArray *)getAllTypeMessageLocalPathOfSessionId:(NSString *)sessionId type:(MessageBodyType)type;

//获取会话中最新消息100条
-(NSArray*)getLatestHundredMessageOfSessionId:(NSString*)sessionId andSize:(NSInteger)pageSize;

-(NSArray*)getMessageOfSessionId:(NSString *)sessionId beforeTime:(NSString*)timetamp andPageSize:(NSInteger)pageSize;

//删除会话的数据
-(void)deleteAllMessageOfSession:(NSString*)sessionId;

//删除会话的数据,保留会话
-(void)deleteAllMessageSaveSessionOfSession:(NSString*)sessionId;

- (void)updateSrcMessage:(NSString*)sessionId msgid:(NSString*)msgId withDstMessage:(ECMessage*)dstmessage;

//获取自定义会话列表
-(NSArray*)getMyCustomSession;

-(void)clearGroupMessageTable;

-(void)markGroupMessagesAsRead;

-(void)updateMessageId:(ECMessage*)msgNewId andTime:(long long)time ofMessageId:(NSString*)msgOldId;

//获取Group通知消息
-(NSArray*)getLatestHundredGroupNotice;

//打开数据库
-(void)openDataBasePath:(NSString*)userName;

-(void)markMessagesAsReadOfSession:(NSString*)sessionId;

-(void)deleteMessage:(ECMessage*)messageId andPre:(ECMessage*)message;

-(void)addNewMessage:(ECMessage*)message andSessionId:(NSString*)sessionId;

-(void)addNewGroupMessage:(ECGroupNoticeMessage*)message;
@end
