//
//  ECNetworkDelegate.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/16.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "ECDelegateBase.h"
#import "ECEnumDefs.h"

/**
 * 该代理用于接收网络改变
 */
@protocol ECNetworkDelegate <ECDelegateBase>

@optional

/**
 @brief 网络改变后调用的代理方法
 @param status 网络状态值
 */
- (void)onReachbilityChanged:(ECNetworkType)status;

@required
@end
