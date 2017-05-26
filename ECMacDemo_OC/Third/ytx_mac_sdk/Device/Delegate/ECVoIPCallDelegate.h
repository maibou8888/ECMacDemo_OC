//
//  ECVoIPCallDelegate.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/1/27.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECDelegateBase.h"
#import "VoipCall.h"

/**
 * VoIP呼叫的代理
 */
@protocol ECVoIPCallDelegate <ECDelegateBase>

@optional

/**
 @brief 有呼叫进入
 @param callid      会话id
 @param caller      主叫人账号
 @param callerphone 主叫人设置的手机号
 @param callername  主叫人设置的昵称
 @param calltype    呼叫类型
 */
- (NSString*)onIncomingCallReceived:(NSString*)callid withCallerAccount:(NSString *)caller withCallerPhone:(NSString *)callerphone withCallerName:(NSString *)callername withCallType:(CallType)calltype;

/**
 @brief 呼叫事件
 @param voipCall VoIP电话实体类的对象
 */
- (void)onCallEvents:(VoIPCall*)voipCall;

/**
 @brief 收到dtmf
 @param callid 会话id
 @param dtmf   键值
 */
- (void)onReceiveFrom:(NSString*)callid DTMF:(NSString*)dtmf;

/**
 @brief 视频分辨率发生改变(此函数已作废，点对点和会议分辨率发生变化，已有各自的代理)
 @param callid       会话id
 @param voip         VoIP号
 @param isConference NO 不是, YES 是
 @param width        宽度
 @param height       高度
 */
- (void)onCallVideoRatioChanged:(NSString *)callid andVoIP:(NSString *)voip andIsConfrence:(BOOL)isConference andWidth:(NSInteger)width andHeight:(NSInteger)height EC_DEPRECATED_IOS(5.1.5, 5.3.0,"Use -onCallVideoRatioChanged:andWidth:andHeight:");

/**
 @brief 视频分辨率发生改变
 @param callid       会话id
 @param width        宽度
 @param height       高度
 */
- (void)onCallVideoRatioChanged:(NSString *)callid andWidth:(NSInteger)width andHeight:(NSInteger)height;

/**
 @brief 收到对方切换音视频的请求
 @param callid  会话id
 @param requestType 请求音视频类型 视频:需要响应 音频:请求删除视频（不需要响应，双方自动去除视频）
 */
- (void)onSwitchCallMediaTypeRequest:(NSString *)callid withMediaType:(CallType)requestType;

/**
 @brief 收到对方应答切换音视频请求
 @param callid   会话id
 @param responseType 回复音视频类型
 */
- (void)onSwitchCallMediaTypeResponse:(NSString *)callid withMediaType:(CallType)responseType;

/**
 @brief 需要获取的离线呼叫CallId (用于苹果推送下来的离线呼叫callid)
 @return apns推送的过来的callid
 */
- (NSString*)onGetOfflineCallId;

/**
 @brief 获取本地回铃音路径
 @param voipCall  呼叫相关信息
 */
- (NSString*)onGetRingBackWavPath:(VoIPCall*)voipCall;

/**
 @brief 获取本地忙音路径
 @param voipCall  呼叫相关信息
 */
- (NSString*)onGetBusyWavPath:(VoIPCall*)voipCall;


- (void)onReceiveThreePartNotify:(NSInteger)var member:(NSString*)member;
@end
