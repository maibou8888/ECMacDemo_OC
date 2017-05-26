//
//  ECGroupOption.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/7.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 群组规则
 */
@interface ECGroupOption : NSObject

/**
 @brief groupId 群组id
 */
@property (nonatomic, copy) NSString *groupId;

/**
 @brief isNotice 消息提示设置 YES:提示(初始化默认值) NO:不提示(免打扰)
 */
@property (nonatomic, assign) BOOL isNotice;

/**
 @brief isPushAPNS 群推送设置 YES:推送苹果服务器(初始化默认值) NO:不推送
 */
@property (nonatomic, assign) BOOL isPushAPNS;
@end
