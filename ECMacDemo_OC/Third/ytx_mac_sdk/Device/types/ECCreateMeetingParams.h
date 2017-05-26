//
//  ECCreateMeetingParams.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/4/13.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECEnumDefs.h"

@interface ECCreateMeetingParams : NSObject

/**
@brief 会议类型
*/
@property (nonatomic, assign) ECMeetingType meetingType;

/**
 @brief 创建者退出后会议是否解散
 */
@property (nonatomic, assign) BOOL autoClose;

/**
 @brief 是否为永久会议
 */
@property (nonatomic, assign) BOOL autoDelete;

/**
 @brief 创建后，是否自动加入会议
 */
@property (nonatomic, assign) BOOL autoJoin;

/**
 @brief 业务属性
 */
@property (nonatomic, copy) NSString *keywords;

/**
 @brief 会议名称
 */
@property (nonatomic, copy) NSString *meetingName;

/**
 @brief 会议密码
 */
@property (nonatomic, copy) NSString *meetingPwd;

/**
 @brief 参与人数 
 */
@property (nonatomic, assign) NSInteger square;

/**
 @brief 会议背景模式 1：无提示音有背景音；2：有提示音有背景音；3：无提示音无背景音；
 */
@property (nonatomic, assign) NSInteger voiceMod;

/**
 @brief 预留字段
 */
@property (nonatomic, copy) NSString *domain;

/**
 @brief 预留字段
 */
@property (nonatomic, assign) NSInteger callbackMode;

/**
 @brief 预留字段
 */
@property (nonatomic, copy) NSString *asUserdata;
@end
