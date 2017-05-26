//
//  VoipCall.h
//  CCPSDKProject
//
//  Created by hubin  on 12-10-11.
//  Copyright (c) 2012年 hisunsray. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, ECallDirect) {
    
    /** 呼出 */
    EOutgoing = 0,
    
    /** 呼入 */
    EIncoming
};

typedef NS_ENUM(NSUInteger, ECallStatus) {
    
    /** 外呼，服务器回100Tring */
    ECallProceeding = 0,   
    
    /** 外呼对方振铃 */
    ECallAlerting,
    
    /** 外呼失败 */
    ECallFailed,
    
    /** 呼叫振铃 */
    ECallRing,
    
    /** 通话，外呼和来电 */
    ECallStreaming,
    
    /** 释放呼叫请求中 */
    ECallReleasing,
    
    /** 呼叫保持 */
    ECallPaused,
    
    /** 呼叫被保持 */
    ECallPausedByRemote,
    
    /** 呼叫恢复 */
    ECallResumed,
    
    /** 呼叫被恢复 */
    ECallResumedByRemote,
    
    /** 呼叫被转移 */
    ECallTransfered,
    
    /** 呼叫释放 */
    ECallEnd
};

typedef NS_ENUM(NSInteger, CallType) {
    
    /** 未知 */
    Unknow = -1,
    
    /** 音频 */
    VOICE = 0,
    
    /** 视频 */
    VIDEO = 1,
    
    /** 网络电话 */
    LandingCall = 2,
   
};

@interface VoIPCall : NSObject

/**
 @brief VoIP电话id
 */
@property (nonatomic, copy) NSString *callID;

/**
 @brief  呼叫者
 */
@property (nonatomic, copy) NSString *caller;

/**
 @brief 被呼叫者
 */
@property (nonatomic, copy) NSString *callee;

/**
 @brief 呼叫方向
 */
@property (nonatomic, assign) ECallDirect callDirect;

/**
 @brief 呼叫状态
 */
@property (nonatomic, assign) ECallStatus callStatus;

/**
 @brief 呼叫类型
 */
@property (nonatomic, assign) CallType callType;

/**
 @brief 呼叫异常出错的原因
 */
@property (nonatomic, assign) NSInteger reason;
@end

/**
 *  voip通话个人信息类
 */
@interface VoIPCallUserInfo : NSObject

/**
 @brief 电话号码
 */
@property (nonatomic, copy) NSString *phoneNum;

/**
 @brief 昵称
 */
@property (nonatomic, copy) NSString *nickName;
@end

#pragma mark - 回拨
/**
 *  回拨电话信息
 */
@interface ECCallBackEntity  : NSObject

/**
 @brief 主叫的电话（加国际码）
 */
@property (nonatomic, copy) NSString *src;

/**
 @brief 被叫的电话（加国际码）
 */
@property (nonatomic, copy) NSString *dest;

/**
 @brief 主叫侧显示的号码，根据平台侧显号规则控制
 */
@property (nonatomic, copy) NSString *srcSerNum;

/**
 @brief 被叫侧显示的客服号码，根据平台侧显号规则控制
 */
@property (nonatomic, copy) NSString *destSerNum;
@end


