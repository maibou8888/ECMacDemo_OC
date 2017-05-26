//
//  ECMessage.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/6.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECMessageBody.h"
#import "ECEnumDefs.h"

/**
 * 消息类，包含发送者，接收者等消息信息
 */
@interface ECMessage : NSObject

/**
 @brief 消息来源用户账号
 */
@property (nonatomic, copy) NSString *from;

/**
 @brief 消息目的地用户账号
 */
@property (nonatomic, copy) NSString *to;

/**
 @brief 消息ID
 */
@property (nonatomic, copy) NSString *messageId;

/**
 @brief 消息体列表
 */
@property (nonatomic, strong) ECMessageBody *messageBody;

/**
 @brief 消息发送或接收的时间(发送消息是本地时间，接收消息是服务器时间)
 */
@property (nonatomic, copy) NSString* timestamp;

/**
 @brief 用户自定义数据（透传）
 */
@property (nonatomic, copy) NSString *userData;

/**
 @brief 会话ID
 */
@property (nonatomic, copy) NSString *sessionId;

/**
 @brief 此消息是否是群聊消息
 */
@property (nonatomic) BOOL isGroup;

/**
 @brief 发送状态
 */
@property (nonatomic) ECMessageState messageState;

/**
 @brief 是否读取过
 */
@property (nonatomic) BOOL isRead;

/**
 @brief 无效字段
 */
@property (nonatomic, copy) NSString *groupSenderName EC_DEPRECATED_IOS(5.0, 5.3.0, "Use - senderName");

/**
 @brief 接收的消息发送者昵称
 */
@property (nonatomic, copy) NSString *senderName;

#ifdef ReadServerFromConfig
/**
 @brief 自定义苹果离线推送消息内容
 */
@property (nonatomic, copy) NSString *apsAlert;

#endif

/**
 @method
 @brief 创建消息实例
 @param receiver 消息接收方
 @param body 消息体
 @result 消息实例
 */
- (instancetype)initWithReceiver:(NSString *)receiver
                body:(ECMessageBody*)body;

@end
