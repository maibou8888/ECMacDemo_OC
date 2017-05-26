//
//  ECConferenceMemberInfo.h
//  CCPiPhoneSDK
//
//  Created by jiazy on 2017/2/17.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger,ECConferenceMemberState) {
    
    /** 不在线 */
    ECConferenceMemberState_Offline = 0x00000000,
    
    /** 在线 */
    ECConferenceMemberState_Online = 0x00000001,
    
    /** 可讲话 */
    ECConferenceMemberState_Speaking = 0x00000002,
    
    /** 有摄像头视频 */
    ECConferenceMemberState_Video = 0x00000003,
    
    /** 共享了屏幕 */
    ECConferenceMemberState_Screen = 0x00000008,
    
    /** 共享了白板 */
    ECConferenceMemberState_ShareWhite = 0x00000010,
    
    /** 非静音状态 */
    ECConferenceMemberState_NoMute = 0x00000020
};

typedef NS_ENUM(NSUInteger,ECAccountType) {
    
    /** 落地电话 */
    ECAccountType_PhoneNumber = 1,
    
    /** 应用账号 */
    ECAccountType_AppNumber = 2,
};

#pragma mark -
#pragma mark 账号信息
/**
 *  账号信息
 */
@interface ECAccountInfo : NSObject

/**
 @brief 账号ID
 */
@property (nonatomic, copy) NSString* accountId;


/**
 @brief 账号类型
 */
@property (nonatomic, assign) ECAccountType accountType;

@end


#pragma mark -
#pragma mark 会议成员信息
/**
 *  会议成员信息
 */
@interface ECConferenceMemberInfo : NSObject

/**
 @brief 成员账号
 */
@property (nonatomic, strong) ECAccountInfo* member;

/**
 @brief 成员状态
 */
@property (nonatomic, assign) ECConferenceMemberState state;

/**
 @brief 昵称
 */
@property (nonatomic, copy) NSString* userName;

/**
 @brief 预留
 */
@property (nonatomic, copy) NSString* appData;
@end
