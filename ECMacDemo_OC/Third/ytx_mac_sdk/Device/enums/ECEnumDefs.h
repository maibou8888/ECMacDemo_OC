//
//  ECSpeakStatus.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/7.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ECKIT_EXTERN	        extern __attribute__((visibility ("default")))
#define EC_DEPRECATED_IOS(_ecdeviceIntro, _ecdeviceDep, ...) __attribute__((deprecated("")))

/**
 * 重连状态值
 */
typedef NS_ENUM(NSUInteger,ECConnectState) {
    
    /** 连接成功 */
    State_ConnectSuccess=0,
    
    /** 连接中 */
    State_Connecting,
    
    /** 连接失败 */
    State_ConnectFailed
};

/**
 * 群组类型
 */
typedef NS_ENUM(NSInteger,ECGroupType) {
    
    /** 默认是群组 */
    ECGroupType_NONE=0,
    
    /** 讨论组模式 */
    ECGroupType_Discuss = 1,
    
    /** 群组模式 */
    ECGroupType_Group = 2,
    
    /** 全部类型 */
    ECGroupType_All = 125,
};

/**
 * 网络状态值
 */
typedef NS_ENUM(NSInteger,ECNetworkType) {
    
    /** 当前无网络 */
    ECNetworkType_NONE=0,
    
    /** 当前网络是WIFI */
    ECNetworkType_WIFI,
    
    /** 当前网络是4G */
    ECNetworkType_4G,
    
    /** 当前网络是3G */
    ECNetworkType_3G,
    
    /** 当前网络是GPRS */
    ECNetworkType_GPRS,
    
    /** 当前网络为LAN类型 */
    ECNetworkType_LAN,
    
    /** 当前网络为其他 */
    ECNetworkType_Other,
};

typedef NS_ENUM(NSInteger, ECDeviceType) {
    
    /** 未知设备类型 */
    ECDeviceType_Unknow = 0,
    
    /** Android手机 */
    ECDeviceType_AndroidPhone = 1,
    
    /** iPhone手机 */
    ECDeviceType_iPhone = 2,
    
    /** iPad平板 */
    ECDeviceType_iPad = 10,
    
    /** Android平板 */
    ECDeviceType_AndroidPad = 11,
    
    /** PC电脑 */
    ECDeviceType_PC = 20,
    
    /** web */
    ECDeviceType_Web = 21,
    
    /** Mac */
    ECDeviceType_Mac = 22,
};

/**
 * 群组成员禁言状态
 */
typedef NS_ENUM(NSInteger,ECSpeakStatus){
    
    /** 允许发言 */
    ECSpeakStatus_Allow=1,
    
    /** 禁止发言 */
    ECSpeakStatus_Forbid
};

/**
 * 性别
 */
typedef NS_ENUM(NSInteger,ECSexType){
    
    /** 男 */
    ECSexType_Male=1,
    
    /** 女 */
    ECSexType_Female
};

/**
 * 群组成员角色
 */
typedef NS_ENUM(NSInteger,ECMemberRole){
    
    /** 创建者 */
    ECMemberRole_Creator=1,
    
    /** 管理员 */
    ECMemberRole_Admin,
    
    /** 普通成员 */
    ECMemberRole_Member
};

/**
 * 验证类型
 */
typedef NS_ENUM(NSInteger,ECAckType) {
    
    /** 不需要验证 */
    EAckType_None=0,
    
    /** 拒绝 */
    EAckType_Reject=1,
    
    /** 同意 */
    EAckType_Agree=2,
    
    /** 已处理 */
    EAckType_Done=3,
};

/**
 * 发送状态
 */
typedef NS_ENUM(NSInteger,ECMessageState) {
    
    /** 发送失败 */
    ECMessageState_SendFail=-1,
    
    /** 发送成功 */
    ECMessageState_SendSuccess=0,
    
    /** 发送中 */
    ECMessageState_Sending=1,
    
    /** 接收成功 */
    ECMessageState_Receive=2,
};


/**
 * 旋转角度
 */
typedef NS_ENUM(NSUInteger, ECRotate) {
    
    /** 默认自动 */
    Rotate_Auto,
    
    /** 旋转角度0 */
    Rotate_0,
    
    /** 旋转角度90 */
    Rotate_90,
    
    /** 旋转角度180 */
    Rotate_180,
    
    /** 旋转角度270 */
    Rotate_270
};


/**
 * 音频设置类型
 */
typedef NS_ENUM(NSUInteger,ECAudioType)
{
    /** 自动增益控制,默认底层是关闭,开启后默认模式是kAgcAdaptiveAnalog */
    eAUDIO_AGC,
    
    /** 回音消除,默认开启,模式默认是kEcAecm */
    eAUDIO_EC,
    
    /** 静音抑制,默认开启,模式默认是kNsVeryHighSuppression */
    eAUDIO_NS
};


/**
 * 静音抑制模式
 */
typedef NS_ENUM(NSUInteger,ECAudioNsMode)
{
    /** previously set mode */
    eNsUnchanged = 0,
    
    /** platform default */
    eNsDefault,
    
    /** conferencing default */
    eNsConference,
    
    /** lowest suppression */
    eNsLowSuppression,
    
    /** midddle suppression */
    eNsModerateSuppression,
    
    /** high suppression */
    eNsHighSuppression,
    
    /** highest suppression */
    eNsVeryHighSuppression,
};


/**
 * 自动增益模式
 */
typedef NS_ENUM(NSUInteger,ECAudioAgcMode)
{
    /** Unchanged */
    eAgcUnchanged = 0,
    
    /** platform default */
    eAgcDefault,
    
    /** adaptive mode for use when analog volume control exists (e.g. for PC softphone) */
    eAgcAdaptiveAnalog,
    
    /** scaling takes place in the digital domain (e.g. for conference servers and embedded devices) */
    eAgcAdaptiveDigital,
    
    /** can be used on embedded devices where the capture signal level is predictable */
    eAgcFixedDigital
};


/**
 * 回音消除模式
 */
typedef NS_ENUM(NSUInteger, ECAudioEcMode)
{
    /** previously set mode */
    eEcUnchanged = 0,
    
    /** platform default */
    eEcDefault,
    
    /** conferencing default (aggressive AEC) */
    eEcConference,
    
    /** Acoustic Echo Cancellation */
    eEcAec,
    
    /** AEC mobile */
    eEcAecm,
};

/**
 * 防火墙类型
 */
typedef NS_ENUM(NSUInteger,APPFirewallPolicy)
{
    /** 无防火墙 */
    phonePolicyNoFirewall = 0,
    
    /** 使用防火墙 */
    phonePolicyUseIce
};

/**
 * 编解码
 */
typedef NS_ENUM(NSUInteger,ECCodec)  {
    Codec_iLBC = 0,//SDK不支持
    Codec_G729 = 1,
    Codec_PCMU = 2,
    Codec_PCMA = 3,//SDK不支持
    Codec_H264 = 4,
    Codec_SILK8K = 5,//SDK不支持
    Codec_AMR = 6,//SDK不支持
    Codec_VP8 = 7,
    Codec_SILK16K = 8,//SDK不支持
    Codec_OPUS48 = 9,
    Codec_OPUS16 = 10,
    Codec_OPUS8 = 11
};

/**
 * 会议房间的类型
 */
typedef NS_ENUM(NSInteger,ECMeetingType) {
    
    /** 语音群聊类型 */
    ECMeetingType_MultiVoice = 1,
    
    /** 多路视频类型 */
    ECMeetingType_MultiVideo = 2,
    
    /** 实时对讲类型 */
    ECMeetingType_Interphone = 3,
    
    /** 数据会议 */
    ECMeetingType_Screen = 4,
    
    /** 音频+数据会议 */
    ECMeetingType_ScreenVoice = 5,
    
    /** 音视频+数据会议 */
    ECMeetingType_ScreenVideo = 6
};

typedef enum
{
    SYSNone = 0,
    SYSCallDialing,
    SYSCallIncoming,
    SYSCallDisconnected,
    SYSCallConnected
}CCPEvents;

/**
 * 个人在线状态子类型
 */
typedef NS_ENUM(NSInteger,ECPresenceType) {

    /** 请勿打扰 */
    ECPresenceType_NotDisturb = 1,
    
    /** 离开 */
    ECPresenceType_leave = 2,
    
    /** 忙碌 */
    ECPresenceType_Busying = 3,
    
    /** 隐身 */
    ECPresenceType_Hidden = 4,
};
