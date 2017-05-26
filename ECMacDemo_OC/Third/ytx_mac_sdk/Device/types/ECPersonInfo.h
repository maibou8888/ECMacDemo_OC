//
//  ECPersonInfo.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/3/24.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECEnumDefs.h"

/**
 *  个人信息类
 */
@interface ECPersonInfo : NSObject

/**
 @brief 用户账号
 */
@property (nonatomic, copy) NSString *userAcc;

/**
 @brief 昵称
 */
@property (nonatomic, copy) NSString *nickName;

/**
 @brief 性别
 */
@property (nonatomic, assign) ECSexType sex;

/**
 @brief 生日 时间格式 yyyy-MM-dd
 */
@property (nonatomic, copy) NSString *birth;

/**
 @brief 签名
 */
@property (nonatomic, copy) NSString *sign;

/**
 @brief 信息版本
 */
@property (nonatomic, assign) long long version;
@end
