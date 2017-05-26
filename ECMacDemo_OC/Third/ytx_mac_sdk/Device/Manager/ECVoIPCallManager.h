//
//  ECVoIPCallManager.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/1/26.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif
#import "ECManagerBase.h"
#import "ECError.h"
#import "VoipCall.h"
@protocol ECVoIPCallManager<ECManagerBase>

/**
 * 回拨电话
 * callBAckEntity ECCallBackEntity 对象
 * @param completion 执行结果回调block
 */
- (void)makeCallback:(ECCallBackEntity *)callBackEntity completion:(void(^)(ECError *error, ECCallBackEntity* callBackEntity))completion;

/**
 @brief 拨打电话
 @param callType 电话类型
 @param called 电话号(加国际码)或者VoIP号码
 @return 本次电话的id
 */
- (NSString *)makeCallWithType:(CallType)callType andCalled:(NSString *)called;

/**
 @brief 挂断电话
 @param callid 电话id
 @return 0:成功  非0:失败
 */
- (NSInteger)releaseCall:(NSString *)callid;

/**
 @brief 挂断电话
 @param callid 电话id
 @param reason 预留参数,挂断原因值，可以传入大于1000的值，通话对方会在onMakeCallFailed收到该值
 @return 0:成功  非0:失败
 */
- (NSInteger)releaseCall:(NSString *)callid andReason:(NSInteger) reason;

/**
 @brief 接听电话
 @param callid 电话id
 V2.0
 @return 0:成功  非0:失败
 */
- (NSInteger)acceptCall:(NSString*)callid EC_DEPRECATED_IOS(5.1.0, 5.1.5,"Use - acceptCall: withType:");

/**
 @brief 接听电话
 @param callid 电话id
 @param callType 电话类型
 V2.1
 @return 0:成功  非0:失败
 */
- (NSInteger)acceptCall:(NSString*)callid withType:(CallType)callType;

/**
 @brief 拒绝呼叫(挂断一样,当被呼叫的时候被呼叫方的挂断状态)
 @param callid 电话id
 @param reason 拒绝呼叫的原因, 可以传入ReasonDeclined:用户拒绝 ReasonBusy:用户忙
 @return 0:成功  非0:失败
 */
- (NSInteger)rejectCall:(NSString *)callid andReason:(NSInteger) reason;

/**
 @brief 保持通话
 @param callid 电话id
 @return 0:成功  非0:失败
 */
- (NSInteger)pauseCll:(NSString*)callid;

/**
 @brief 恢复通话
 @param callid 电话id
 @return 0:成功  非0:失败
 */
- (NSInteger)resumeCall:(NSString*)callid;

/**
 @brief 获取当前通话的callid
 @return 电话id
 */
-(NSString*)getCurrentCall;

/**
 @brief 请求切换音视频
 @param callType 请求的音视频类型
 @return 是否成功 0:成功；非0失败
 */
- (NSInteger)requestSwitchCallMediaType:(NSString*)callid toMediaType:(CallType)callType;

/**
 @brief 回复对方的切换音视频请求
 @param callType 回复的音视频类型
 @return 是否成功 0:成功；非0失败
 */
- (NSInteger)responseSwitchCallMediaType:(NSString*)callid withMediaType:(CallType)callType;

/**
 @brief 发送DTMF
 @param callid 电话id
 @param dtmf 键值
 @return 0:成功  非0:失败
 */
- (NSInteger)sendDTMF:(NSString *)callid dtmf:(NSString *)dtmf;

@end
