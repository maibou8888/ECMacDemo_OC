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

#import <Foundation/Foundation.h>
#import "ECMessage.h"
#import "ECGroupNoticeMessage.h"
#import "FMDB.h"
#import "ECSession.h"
#import "ECDeviceHeaders.h"

#define locationTitle @"title"
#define locationLat   @"lat"
#define locationLon   @"lon"

@interface IMMsgDBAccess : NSObject

+(IMMsgDBAccess*)sharedInstance;
- (void)openDatabaseWithUserName:(NSString*)userName;

#pragma mark 消息操作API
//获取会话列表
-(NSMutableDictionary*)loadAllSessions;
- (NSMutableDictionary *)loadAllTopSessions:(BOOL)isTop;
- (void)updateSession:(ECSession*)session;
- (void)deleteSession:(NSString*)sessionId;

//增加单条消息
-(BOOL)addMessage:(ECMessage*)message;

//删除单条消息
-(BOOL)deleteMessage:(NSString*)msgId andSession:(NSString*)sessionId;

//删除某个会话的所有消息
-(NSInteger)deleteMessageOfSession:(NSString*)sessionId;

//获取某个会话的所有会话内容
- (NSArray *)getAllMessageOfSessionId:(NSString *)sessionId;

//获取某个会话的内容为本地地址的数组
- (NSArray *)getAllLocalPathMessageOfSessionId:(NSString *)sessionId type:(MessageBodyType)messageBodyType;

-(NSInteger)getUnreadMessageCountFromSession;

-(ECMessage*)getMessagesWithMessageId:(NSString*)messageId  OfSession:(NSString *)sessionId;

//获取会话的某个时间点之前的count条消息
-(NSArray*)getSomeMessagesCount:(NSInteger)count OfSession:(NSString*)sessionId beforeTime:(long long)timesamp;
-(NSArray*)getLatestSomeMessagesCount:(NSInteger)count OfSession:(NSString *)sessionId;
//获取会话的某个时间点之后的count条消息
-(NSArray*)getSomeMessagesCount:(NSInteger)count OfSession:(NSString*)sessionId afterTime:(long long)timesamp;

//更新某消息的状态
-(BOOL)updateState:(ECMessageState)state ofMessageId:(NSString*)msgId andSession:(NSString*)session;

//重发，更新某消息的消息id
-(BOOL)updateMessageId:(NSString*)msdNewId andTime:(long long)time ofMessageId:(NSString*)msgOldId andSession:(NSString*)session ;

-(BOOL)updateMessageStateFailedAndSessionId:(NSString*)session;

//更新消息的已读未读状态
-(BOOL)updateMessageReadState:(NSString*)sessionId messageId:(NSString*)messageId isRead:(BOOL)isRead;

-(BOOL)updateNoTop;
//更新会话是否置顶
-(BOOL)updateIsTopSessionId:(NSString*)sessionId isTop:(BOOL)isTop;

- (BOOL)updateMessage:(NSString*)sessionId msgid:(NSString*)msgId withMessage:(ECMessage*)message;
//修改单条消息的下载路径和下载状态
-(BOOL)updateMessageLocalPath:(NSString*)msgId withPath:(NSString*)path withDownloadState:(ECMediaDownloadStatus)state andSession:(NSString*)sessionId;

#pragma mark 群组消息操作API

//增加一条消息
-(BOOL)addGroupMessage:(ECGroupNoticeMessage*)message;

//增加多条消息
-(NSInteger)addGroupMessages:(NSArray*)messages;

-(NSInteger)addGroupIDs:(NSArray*)messages;

-(NSString *)getGroupNameOfId:(NSString *)groupId;

-(BOOL)isNoticeOfGroupId:(NSString *)groupId;

-(void)setIsNotice:(BOOL)isNotice ofGroupId:(NSString *)groupId;
//删除关于某群组的所有消息
-(NSInteger)deleteGroupMessagesOfGroup:(NSString*)groupId;

//清空表
-(NSInteger)clearGroupMessageTable;

//获取表中所有未读消息数
-(NSInteger)getUnreadGroupMessageCount;

//获取确定群组的未读消息数
-(NSInteger)getUnreadGroupMessageCountOfGroup:(NSString*)groupId;

//获取表中消息数
-(NSInteger)getAllGroupMessageCount;

//获取表中确定群组消息数
-(NSInteger)getAllGroupMessageCountOfGroup:(NSString*)groupId;

//获取群组中的count条数据
-(NSArray*)getSomeGroupMessagesCount:(NSInteger)count;
- (NSArray *)getGroupSessionArray;

//获取群组中某个时间点之前的count条数据
-(NSArray*)getSomeGroupMessagesCount:(NSInteger)count OfGroup:(NSString*)group beforeTime:(long long)timesamp;

//标记某群组中所有消息已读
-(NSInteger)markGroupMessagesAsReadOfGroup:(NSString*)groupId;
-(NSInteger)markGroupMessagesAsDownOfGroup:(NSString*)groupId andMemberId:(NSString*)member;
-(NSInteger)markGroupMessagesAsDownOfGroup:(NSString*)groupId andAdminId:(NSString*)admin;

//标记表中所有消息已读
-(NSInteger)markGroupMessagesAsRead;

- (NSString*)getUserName:(NSString*)userId;
- (ECSexType)getUserSex:(NSString*)userId;
- (void) addUserName:(NSString *)userId name:(NSString*)name andSex:(ECSexType)sex;

//判断当前是群组或者讨论组 0 群组 1讨论组
-(BOOL)isDiscussOfGroupId:(NSString *)groupId;
@end
