//
//  ECConferenceVideoInfo.h
//  CCPiPhoneSDK
//
//  Created by jiazy on 2017/2/18.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif
#import "ECConferenceMemberInfo.h"

typedef NS_ENUM(NSUInteger,ECConferenceSourceType) {
    
    /** 摄像头视频 */
    ECConferenceSourceType_Video = 1,
    
    /** 共享屏幕 */
    ECConferenceSourceType_Screen = 2,
};

/**
 *  会议视频信息
 */
@interface ECConferenceVideoInfo : NSObject

/**
 @brief 会议ID
 */
@property (nonatomic, copy) NSString* conferenceId;

/**
 @brief 会议密码
 */
@property (nonatomic, copy) NSString* password;

/**
 @brief 视频源
 */
@property (nonatomic, assign) ECConferenceSourceType sourceType;

/**
 @brief 视频属于的用户
 */
@property (nonatomic, strong) ECAccountInfo *member;

/**
 @brief 本地显示窗口
 */
#if TARGET_OS_IPHONE
@property (nonatomic, strong) UIView *view;
#else
@property (nonatomic, strong) NSView *view;
#endif


@end
