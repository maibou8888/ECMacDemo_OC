//
//  ECSystemDelegate.m
//  CCPiPhoneSDK
//
//  Created by admin on 15/9/14.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import "ECDelegateBase.h"
#import "ECEnumDefs.h"

/**
 * 该代理用于接收网络改变
 */
@protocol ECSystemDelegate <ECDelegateBase>

@optional

/**
 @brief 系统事件通知
 @param CCPEvents 包含的系统事件
 */
- (void)onSystemEvents:(CCPEvents)events;
@end