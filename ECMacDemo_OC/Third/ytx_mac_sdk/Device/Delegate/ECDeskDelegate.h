//
//  ECDeskDelegate.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/5/18.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//


#import "ECDelegateBase.h"
#import "ECMessage.h"
#import "ECMcmCmdMessage.h"

/**
 * 该代理接收客服消息
 */
@protocol ECDeskDelegate <ECDelegateBase>

@optional
/**
 @brief 多渠道消息
 @param message 消息
 */
-(void)onReceiveDeskMessage:(ECMessage*)message;

/**
 @brief 收到多渠道命令消息
 @param message 消息
 */
-(void)onReceiveMcmCmdMessage:(ECMcmCmdMessage*)message;
@end
