//
//  ECError.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/5.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 错误类型枚举值
 */
typedef NS_ENUM(NSInteger,ECErrorType) {
    
    /** 服务器连接中... */
    ECErrorType_Connecting = 100,
    
    /** 无错误，成功 */
    ECErrorType_NoError = 200,
    
    /** 内容长度超过规定 */
    ECErrorType_ContentTooLong = 170001,
    
    /** 必选参数为空 */
    ECErrorType_IsEmpty = 170002,
    
    /** 未登录 */
    ECErrorType_NotLogin = 170003,
    
    /** 正在录音，当前只能录制一个，请先停止 */
    ECErrorType_IsRecording = 170005,
    
    /** 录音超时，60秒长度 */
    ECErrorType_RecordTimeOut = 170006,
    
    /** 录音已经停止，当前未录音调用停止录音 */
    ECErrorType_RecordStoped = 170007,
    
    /** 录音时间过短，不超过1秒 */
    ECErrorType_RecordTimeTooShort = 170008,
    
    /** 文件不存在 */
    ECErrorType_FileNotExist = 170011,
    
    /** 传入的参数类型错误 */
    ECErrorType_TypeIsWrong = 170012,
    
    /** SDK版本不支持 */
    ECErrorType_SDKUnSupport = 170013,
    
    /** 对方SDK版本不支持 */
    ECErrorType_CalleeSDKUnSupport = 170014,
    
    /** 未生成CallID */
    ECErrorType_NO_CallID = 170015,
    
    /** SDK无配置文件 */
    ECErrorType_SDK_NO_ConfigFile = 170016,
    
    /** 线路被占用 */
    ECErrorType_LocalCallBusy = 170486,
        
	/** 未响应 */
    ECErrorType_NoResponse = 175001,
    
    /** 您的设备在其他地方登陆，被踢 */
    ECErrorType_KickedOff = 175004,
    
    /** 对方不在线 */
    ECErrorType_OtherSideOffline = 175404,
    
    /** 呼叫超时 */
    ECErrorType_Timeout = 175408,
    
    /** 未接通 */
    ECErrorType_CallMissed = 175409,
    
    /** 离开 */
    ECErrorType_Gone = 175410,
    
    /** 短期内未获取 */
    ECErrorType_TemporarilyNotAvailable = 175480,
    
    /** 线路被占用 */
    ECErrorType_CallBusy = 175486,
    
    /** 线路忙 */
    ECErrorType_Declined = 175603,
    
    /** 会议不存在 */
    ECErrorType_NotExist = 175707,
    
    /** 密码验证失败 */
    ECErrorType_PasswordInvalid = 175708,
    
    /** MD5Token为空 */
    ECErrorType_MD5TokenIsEmpty = 520003,
    
    /** 时间戳为空 */
    ECErrorType_TimestampIsEmpty = 520004,
    
    /** Apptoken为空 */
    ECErrorType_ApptokenIsEmpty = 520005,
    
    /** MD5Token超过失效时间 */
    ECErrorType_MD5TokenTimeInvalid = 520007,
    
    /** MD5Token无效 */
    ECErrorType_MD5TokenIsInvalid = 520008,
    
    /** token认证失败 */
    ECErrorType_TokenAuthFailed = 520016,
    
    /** 鉴权服务器异常 */
    ECErrorType_AuthServerException = 529999,
    
    /** 连接服务器异常 */
    ECErrorType_ConnectorServerException = 559999,
    
    /** 不在该群组中 */
    ECErrorType_File_NoJoined = 560072,
    
    /** 发送附件被禁言 */
    ECErrorType_File_Have_Forbid = 560073,
    
    /** 发送文本被禁言 */
    ECErrorType_Have_Forbid = 580010,

    /** 已经加入在群组中 */
    ECErrorType_Have_Joined = 590017,
};

/**
 * 错误类
 */
@interface ECError : NSObject

/**
 @property
 @brief 错误类型
 */
@property (nonatomic, readonly) ECErrorType errorCode;

/**
 @property
 @brief 错误类型描述
 */
@property (nonatomic, copy) NSString *errorDescription;

/**
 @param errorCode 错误类型
 @return 错误
 */

+ (ECError *)errorWithCode:(ECErrorType)errorCode;

/**
 @param error 错误
 @return 错误
 */
+ (ECError *)errorWithNSError:(NSError *)error;

@end
