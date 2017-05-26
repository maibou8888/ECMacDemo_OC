//
//  ECProgressDelegate.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/7.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "ECMessage.h"

/**
 * 消息发送进度代理
 */
@protocol ECProgressDelegate <NSObject>

/**
 @brief 设置进度
 @discussion 用户需实现此接口用以支持进度显示
 @param progress 值域为0到1.0的浮点数
 @param message  某一条消息的progress
 @result
 */
- (void)setProgress:(float)progress forMessage:(ECMessage *)message;

@required

@end
