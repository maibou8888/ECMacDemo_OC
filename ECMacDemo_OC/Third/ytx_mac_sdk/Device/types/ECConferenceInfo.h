//
//  ECConferenceInfo.h
//  CCPiPhoneSDK
//
//  Created by jiazy on 2017/2/17.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECConferenceMemberInfo.h"

typedef NS_ENUM(NSInteger,ECConferenceType) {
        
    /** 临时会议 */
    ECConferenceType_Temporary = 0,
    
    /** 永久会议 */
    ECConferenceType_Permanent = 1,
    
    /** 预约会议 */
    ECConferenceType_Subscribe = 2,
};

typedef NS_ENUM(NSInteger,ECConferenceVoiceMode) {
    
    /** 只有背景音 */
    ECConferenceVoiceMode_OnlyBackground = 0,
    
    /** 背景音提示音 */
    ECConferenceVoiceMode_All = 1,
    
    /** 无背景音 */
    ECConferenceVoiceMode_None = 2,
    
    /** 只有提示音 */
    ECConferenceVoiceMode_OnlyPrompt = 3
};

typedef NS_ENUM(NSInteger,ECConferenceMode) {
    
    /** 自由模式 */
    ECConferenceMode_free = 0,
    
    /** 主持人模式 */
    ECConferenceMode_host = 1,
};

/**
 *  会议信息
 */
@interface ECConferenceInfo : NSObject

/**
 @brief 会议ID
 */
@property (nonatomic, copy) NSString* conferenceId;

/**
 @brief 创建者
 */
@property (nonatomic, strong) ECAccountInfo* creator;

/**
 @brief 会议名称
 */
@property (nonatomic, copy) NSString* confName;

/**
 @brief 创建者密码
 */
@property (nonatomic, copy) NSString* ownerPassword;

/**
 @brief 普通成员密码
 */
@property (nonatomic, copy) NSString* password;

/**
 @brief 会议类型
 */
@property (nonatomic, assign) ECConferenceType confType;

/**
 @brief 最大成员数
 */
@property (nonatomic, assign) NSInteger maxMember;

/**
 @brief 背景音类型
 */
@property (nonatomic, assign) ECConferenceVoiceMode voiceMode;

/**
 @brief 0:自由模式，1:主持人模式
 */
@property (nonatomic, assign) ECConferenceMode confMode;

/**
 @brief 主持人离开会议后，会议是否自动结束 (0:否，1:是)
 */
@property (nonatomic, assign) NSInteger autoClose;

/**
 @brief 指定会议主持人ID
 */
@property (nonatomic, assign) NSString *moderator;

/**
 @brief 预约的会议中使用这个字段，会议开始时间
        格式:yyyy-MM-dd HH:mm:ss
 */
@property (nonatomic, copy) NSString *startTime;

/**
 @brief 预约的会议中使用这个字段，预约的参会成员
 */
@property (nonatomic, copy) NSArray *members;

/**
 @brief 预约的会议中使用这个字段，会议持续时间
        单位:分钟 默认值60
 */
@property (nonatomic, assign) NSInteger duration;

/**
 @brief 到时间之后是否发送入会邀请
        (对于应用账号发送邀请通知，对于手机号发起邀请呼叫)
        0:否，1:是 默认值 1
 */
@property (nonatomic, assign) NSInteger sendInvitation;

/**
 @brief 预约的会议中使用这个字段，会议开始前多久发送提醒通知
        单位:分钟 默认值10
 */
@property (nonatomic, assign) NSInteger remindBeforeStart;

/**
 @brief 预约的会议中使用这个字段，会议结束前多久发送提醒通知
        单位:分钟 默认值10
 */
@property (nonatomic, assign) NSInteger remindBeforeEnd;

/**
 @brief 预留
 */
@property (nonatomic, copy) NSString* appData;

@end
