//
//  ECGroupDelegate.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/13.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECDelegateBase.h"
#import "ECGroupNoticeMessage.h"

/**
 * 该代理用于接收群组操作相关的消息，如有人加入群组、退出群组、有人邀请加入等
 */
@protocol ECGroupDelegate <ECDelegateBase>
@optional

/**
 @brief 接收群组相关消息
 @discussion 参数要根据消息的类型，转成相关的消息类；
             解散群组、收到邀请、申请加入、退出群组、有人加入、移除成员等消息
 @param groupMsg 群组消息
 */
-(void)onReceiveGroupNoticeMessage:(ECGroupNoticeMessage *)groupMsg;

@required

@end
