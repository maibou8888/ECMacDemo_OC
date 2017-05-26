//
//  ECDeskManager.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/5/18.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import "ECManagerBase.h"
#import "ECError.h"

/**
 * 坐席事件类型
 */
typedef NS_ENUM(NSInteger,ECMCMEventType)
{
    MCMEventType_UserEvt_StartAsk = 1,
    MCMEventType_UserEvt_EndAsk = 2,
    MCMEventType_UserEvt_SendMSG = 3,
    MCMEventType_UserEvt_SendMail = 4,
    MCMEventType_UserEvt_SendWXMsg = 5,
    MCMEventType_UserEvt_GetAGList = 6,
    MCMEventType_UserEvt_RespAGList = 7,
    MCMEventType_UserEvt_IRCN = 8,
    MCMEventType_UserEvt_SendMCM = 9,
    MCMEventType_NotifyUser_QueueInfo = 10,
    MCMEventType_NotifyUser_StartAskResp = 11,
    MCMEventType_NotifyUser_EndAskResp = 12,
    MCMEventType_NotifyUser_StartConf = 13,
    MCMEventType_NotifyUser_StopConf = 14,
    MCMEventType_NotifyUser_EndAsk = 15,
    MCMEventType_NotifyUser_IRItemList = 16,
    MCMEventType_UserEvt_SelectItem = 17,
    MCMEventType_NotifyUser_InvestigateData = 20,
    MCMEventType_UserEvt_SubmitInvestigate = 21,
    MCMEventType_UserEvt_ServiceUpgrade = 22,
    MCMEventType_NotifyAgent_ServiceUpgradeResp = 23,
    MCMEventType_AgentEvt_KFOnWork = 47,
    MCMEventType_AgentEvt_KFOffWork = 49,
    MCMEventType_AgentEvt_KFStateOpt = 51,
    MCMEventType_NotifyAgent_KFStateResp = 52,
    MCMEventType_AgentEvt_SendMCM = 53,
    MCMEventType_AgentEvt_TransKF = 55,
    MCMEventType_NotifyAgent_TransKFResp = 56,
    MCMEventType_AgentEvt_EnterCallService = 57,
    MCMEventType_NotifyAgent_EnterCallSerResp = 58,
    MCMEventType_NotifyAgent_NewUserAsk = 59,
    MCMEventType_NotifyAgent_UserEndAsk = 60,
    MCMEventType_NotifyAgent_ImHistory = 61,
    MCMEventType_AgentEvt_Ready = 65,
    MCMEventType_AgentEvt_NotReady = 66,
    MCMEventType_AgentEvt_StartSerWithUser = 67,
    MCMEventType_AgentEvt_StopSerWithUser = 68,
    MCMEventType_AgentEvt_TransferQueue = 69,
    MCMEventType_AgentEvt_StartConf = 70,
    MCMEventType_AgentEvt_MakeCall = 71,
    MCMEventType_AgentEvt_AnswerCall = 72,
    MCMEventType_AgentEvt_ReleaseCall = 73,
    MCMEventType_AgentEvt_SendNotify = 74,
    MCMEventType_AgentEvt_ExitConf = 75,
    MCMEventType_NotifyAgent_NewUserCallin = 76,
    MCMEventType_NotifyAgent_UserReleaseCall = 77,
    MCMEventType_NotifyAgent_UserCallEstablish = 80,
    MCMEventType_AgentEvt_RejectUser = 81,
    MCMEventType_NotifyAgent_RejectUserResp = 82,
    MCMEventType_NotifyAgent_StartConfResp = 83,
    MCMEventType_NotifyAgent_ExitConfResp = 84,
    MCMEventType_NotifyAgent_ExitConf = 85,
    MCMEventType_NotifyAgent_InviteJoinConf = 86,
    MCMEventType_AgentEvt_ForceJoinConf = 87,
    MCMEventType_NotifyAgent_TransferNewUser = 89,
    MCMEventType_NotifyAgent_TransferQueueResp = 90,
    MCMEventType_NotifyAgent_FroiceStartConf = 91,
    MCMEventType_AgentEvt_ForceTransfer = 92,
    MCMEventType_NotifyAgent_ForceTransferResp = 93,
    MCMEventType_NotifyAgent_ForceTransfernewUser = 94,
    MCMEventType_NotifyAgent_CallState = 95,
    MCMEventType_AgentEvt_QueryQueueInfo = 97,
    MCMEventType_NotifyAgent_QueryQueueInfoResp = 98,
    MCMEventType_AgentEvt_ReservedForUser = 100,
    MCMEventType_NotifyAgent_ReservedForUserResp = 101,
    MCMEventType_AgentEvt_CancelReserved = 102,
    MCMEventType_NotifyAgent_CancelReservedResp = 103,
    MCMEventType_NotifyAgent_ReservedUserAsk = 104,
    MCMEventType_AgentEvt_StartSessionTimer = 105,
    MCMEventType_NotifyAgent_StartSessionTimerResp = 106,
    MCMEventType_NotifyAgent_STExpired = 107,
    MCMEventType_AgentEvt_MonitorAgent = 108,
    MCMEventType_NotifyAgent_MonitorAgentResp = 109,
    MCMEventType_AgentEvt_CancelMonitorAgent = 110,
    MCMEventType_NotifyAgent_CancelMonitorAgentResp = 111,
    MCMEventType_AgentEvt_QueryAgentInfo = 112,
    MCMEventType_NotifyAgent_QueryAgentInfoResp = 113,
    MCMEventType_AgentEvt_SerWithTheUser = 114,
    MCMEventType_AgentEvt_ForceEndService = 118,
    MCMEventType_NotifyAgent_ForceEndService = 119,
    MCMEventType_NotifyAgent_AgentJoinIM = 127,
    MCMEventType_NotifyAgent_AgentEndIMService = 128,
    MCMEventType_NotifyAgent_ExitIMService = 129,
    MCMEventType_NotifyAgent_TransferResult = 130,
};

/**
 *  客服消息
 */
@protocol ECDeskManager <ECManagerBase>
@optional

/**
 @brief  开始和客服聊天
 @param agent      客服账号
 @param completion 执行结果回调block
 */
-(void)startConsultationWithOSAccount:(NSString*)osAccount andQueueType:(NSInteger)qType upgradeQueueType:(NSInteger)upgradeQType andUserdata:(NSString*)userdata andAccessId:(NSString*)accessid completion:(void(^)(ECError* error, NSString* osAccount))completion;

/**
 @brief 结束聊天
 @param completion 执行结果回调block
 */
-(void)finishConsultation:(void(^)(ECError* error))completion;

/**
 @brief 用户服务升级
 @param completion 执行结果回调block
 */
-(void)userUpgradeService:(void(^)(ECError* error))completion;

/**
 @brief  发送消息
 @param message    发给客服的消息
 @param progress   上传进度
 @param completion 执行结果回调block
 @return 函数调用成功返回消息id，失败返回nil
 */
-(NSString*)sendToDeskMessage:(ECMessage*)message progress:(id<ECProgressDelegate>)progress completion:(void(^)(ECError *error, ECMessage* message))completion;


- (void)submitSatisfaction:(NSString*)satisfaction completion:(void(^)(ECError *error, NSString* satisfaction))completion;

/**
 @brief  发送消息
 @param message    客服回复用户的消息
 @param progress   上传进度
 @param completion 执行结果回调block
 @return 函数调用成功返回消息id，失败返回nil
 */
-(NSString*)sendToUserMessage:(ECMessage*)message progress:(id<ECProgressDelegate>)progress completion:(void(^)(ECError *error, ECMessage* message))completion;

//cc
-(void)setCurrentAgentId:(NSString*)agentId;
-(NSString*)getCurrentAgentId;

-(void)setCurrentCompanyId:(NSString*)companyId;
-(NSString*)getCurrentCompanyId;

-(void)agentLoginWithAgentId:(NSString*)agentId andServerCap:(NSInteger)servercap andQueueType:(NSString*)qType andAgentInfo:(NSDictionary*)agentInfo completion:(void(^)(ECError *error))completion;
-(void)agentLogoutWithQueueType:(NSInteger)qType completion:(void(^)(ECError *error))completion;

-(void)agentReady:(void(^)(ECError *error))completion;
-(void)agentNotReady:(void(^)(ECError *error))completion;

-(void)agentSetReplyType:(NSInteger)type replyLanguage:(NSString*)language ofQueueType:(NSInteger)qType completion:(void(^)(ECError *error))completion;

- (void)agentQueryAgentInfo:(NSString*)agentId completion:(void(^)(ECError *error,NSDictionary *agentInfo))completion;
- (void)agentQueryQueue:(NSInteger)qType completion:(void(^)(ECError *error,NSString* queuecount,NSString* idlecount))completion;

-(void)agentStartWithUser:(NSString*)useraccount withData:(NSString*)data completion:(void(^)(ECError *error, NSString* useraccount))completion;
-(void)agentStopWithUser:(NSString*)useraccount completion:(void(^)(ECError *error, NSString* useraccount))completion;
-(void)agentRejectWithUser:(NSString*)useraccount completion:(void(^)(ECError *error, NSString* useraccount))completion;

-(void)agentStartWithUser:(NSString*)useraccount withAgentId:(NSString*)agentId type:(NSString*)type completion:(void(^)(ECError *error, NSString* useraccount))completion;

-(void)agentTransferUser:(NSString*)useraccount toAgentId:(NSString*)agentId andQueueType:(NSInteger)qType completion:(void(^)(ECError *error, NSString* useraccount))completion;
-(void)agentTransferQueueType:(NSInteger)qType andUser:(NSString*)useraccount completion:(void(^)(ECError *error, NSString* useraccount))completion;
-(void)agentForceTransferUser:(NSString*)useraccount fromAgentId:(NSString*)agentId toAgentId:(NSString*)destAgentId completion:(void(^)(ECError *error, NSString* useraccount))completion;
-(void)agentForceEndServerWithUser:(NSString*)useraccount andAgentId:(NSString*)agentId completion:(void(^)(ECError *error, NSString* useraccount))completion;

-(void)agentStartConfWithUser:(NSString*)useraccount andAgentId:(NSString*)agentId completion:(void(^)(ECError *error, NSString* useraccount))completion;
-(void)agentJoinConfWithUser:(NSString*)useraccount completion:(void(^)(ECError *error, NSString* useraccount))completion;
-(void)agentForceJoinConfWithUser:(NSString*)useraccount completion:(void(^)(ECError *error, NSString* useraccount))completion;
-(void)agentExitConfWithUser:(NSString*)useraccount completion:(void(^)(ECError *error, NSString* useraccount))completion;
-(void)agentStartSessionTimerWithUser:(NSString*)useraccount completion:(void(^)(ECError *error, NSString* useraccount))completion;

-(void)agentEnterCallServiceWithUser:(NSString*)useraccount andPhone:(NSString*)phone completion:(void(^)(ECError *error, NSString* useraccount))completion;

/*
 @brief keyType:0 IM帐号、1 微信帐号、2邮件帐号、3短信发送号、4传真发送号、5自定义文本内容(可以定义为枚举类型）
 */
-(void)agentReservedForUserService:(NSString*)agentId keyType:(NSString*)keyType keyWord:(NSString*)keyWord completion:(void(^)(ECError *error, NSString* agentId))completion;
-(void)agentCancelReservedForUserService:(NSString*)agentId keyType:(NSString*)keyType keyWord:(NSString*)keyWord completion:(void(^)(ECError *error, NSString* agentId))completion;
//恒丰使用接口
-(void)agentManagerWithType:(ECMCMEventType)type andAgentId:(NSString*)agentid andUserAccount:(NSString*)useraccount andCCSType:(NSInteger)ccstype andData:(NSString*)jsonString completion:(void(^)(ECError *error, ECMCMEventType type)) completion;

@required

@end

