//
//  ECSession.h
//  CCPiPhoneSDK
//
//  Created by wang ming on 14-12-10.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface ECSession : NSObject
/**
 @property
 @brief 会话ID
 */
@property (nonatomic, copy) NSString *sessionId;

/**
 @property
 @brief 创建时间 显示的时间 毫秒
 */
@property (nonatomic, assign) long long dateTime;

/**
 @property
 @brief 与消息表msgType一样
 */
@property (nonatomic, assign) int type;

/**
 @property
 @brief 显示的内容
 */
@property (nonatomic, copy) NSString *text;

/**
 @property
 @brief 未读消息数
 */
@property (nonatomic,assign) NSInteger unreadCount;

/**
 @property
 @brief 总消息数
 */
@property (nonatomic, assign) int sumCount;

/**
 @property
 @brief 是否被@了
 */
@property (nonatomic, assign) BOOL isAt;

/**
 @property
 @brief 会话是否置顶
 */
@property (nonatomic, assign) BOOL isTop;

@end
