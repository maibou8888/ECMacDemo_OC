//
//  ECConferenceJoinInfo.h
//  CCPiPhoneSDK
//
//  Created by jiazy on 2017/2/17.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECConferenceMemberInfo.h"
/**
 *  会议加入信息
 */
@interface ECConferenceJoinInfo : NSObject

/**
 @brief 会议ID
 */
@property (nonatomic, copy) NSString *conferenceId;

/**
 @brief 会议密码
 */
@property (nonatomic, copy) NSString *password;

/**
 @brief 用户昵称
 */
@property (nonatomic, copy) NSString *userName;

/**
 @brief 邀请者
 */
@property (nonatomic, copy) NSString *inviter;

/**
 @brief 账号类型
 */
@property (nonatomic, assign) ECAccountType inviterType;

/**
 @brief 预留
 */
@property (nonatomic, copy) NSString *appData;

@end
