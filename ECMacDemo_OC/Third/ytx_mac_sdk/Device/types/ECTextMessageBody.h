//
//  ECTextMessageBody.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/17.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "ECMessageBody.h"

/**
 * 文本消息体
 */
@interface ECTextMessageBody : ECMessageBody
/**
 @brief text 文本消息体的内部文本对象的文本
 */
@property (nonatomic, strong) NSString *text;

/**
 @brief serverTime 时间
 */
@property (nonatomic, strong) NSString *serverTime;

/**
 @brief atArray 发送消息被@的账号
 */
@property (nonatomic, strong) NSArray *atArray;

/**
 @brief isAted 收到消息，是否被发送者@了
 */
@property (nonatomic, assign) BOOL isAted;

/**
 @brief 创建文本实例
 @param text 文本消息
 */
-(instancetype)initWithText:(NSString*)text;

@end
