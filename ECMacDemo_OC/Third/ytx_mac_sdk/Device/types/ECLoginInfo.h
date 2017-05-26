//
//  ECInitialization.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/6.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 登录模式
 */
typedef NS_ENUM(NSUInteger,LoginMode)
{
    /** 用户输入密码登录模式，可以把其他设备踢出 默认值*/
    LoginMode_InputPassword = 1,
    
    /** 直接读取配置登录，如果账号在其他设备登录过，验证失败，错误码是被踢出 */
    LoginMode_AutoInputLogin = 2
};

/**
 * 登录认证类型
 */
typedef NS_ENUM(NSUInteger,LoginAuthType)
{
    /** 正常认证模式，服务器认证appKey、appToken、username字段 默认值 */
    LoginAuthType_NormalAuth = 1,
    
    /** 密码认证模式，服务器认证appKey、username、userPassword字段 */
    LoginAuthType_PasswordAuth = 3,
    
    /** MD5 Token认证方式，服务器认证appKey、username、timestamp、MD5Token字段
     * (该鉴权方式是最安全的方式，用户在自己的服务器根据规则生成MD5，在不暴露apptoken的情况下进行鉴权，且生成的MD5 Token在平台上有失效时间)
     */
    LoginAuthType_MD5TokenAuth = 4,
    
    /** 临时密码认证模式（临时密码有一定的有效期，有效期过后需要重新生成临时密码进行认证） */
    LoginAuthType_TempPasswordAuth = 5
};

/**
 * 登录所需信息
 */
@interface ECLoginInfo : NSObject

/**
 @brief mode 认证类型
 */
@property (nonatomic, assign) LoginAuthType authType;

/**
 @brief mode 登录模式
 */
@property (nonatomic, assign) LoginMode mode;

/**
 @brief username 登录用户名，需要第三方用户自己维护
*/
@property (nonatomic, copy) NSString *username;

/**
 @brief userPassword 用户密码字段
 */
@property (nonatomic, copy) NSString *userPassword;

/**
 @brief appKey 用户在云通讯平台生成应用时的appKey
 */
@property (nonatomic, copy) NSString *appKey;

/**
 @brief appToken 用户在云通讯平台生成应用时的appToken
 */
@property (nonatomic, copy) NSString *appToken;

/**
 @brief timestamp 用户生成MD5的时间戳 yyyyMMddHHmmss
 */
@property (nonatomic, copy) NSString *timestamp;

/**
 @brief MD5Token 用户生成的MD5值 MD5(appId+userName+timestamp+apptoken)
 */
@property (nonatomic, copy) NSString *MD5Token;
@end
