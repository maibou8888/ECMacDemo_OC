//
//  ECMessageNotifyMsg.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/10/31.
//  Copyright © 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef NS_ENUM(NSUInteger, ECMessageNotifyType) {
    
    /** 删除消息通知 */
    ECMessageNotifyType_DeleteMessage = 0,
    
    /** 撤回消息通知 */
    ECMessageNotifyType_RevokeMessage = 1,
    
    /** 消息已读通知 */
    ECMessageNotifyType_MessageIsReaded = 3,
};

#pragma mark - 消息操作通知基类
/**
 * 消息操作通知基类
 */
@interface ECMessageNotifyMsg : NSObject

/**
 @brief 消息类型
 */
@property (nonatomic, readonly) ECMessageNotifyType messageType;
@end

#pragma mark - 消息删除通知
/**
 * 消息删除通知
 */
@interface ECMessageDeleteNotifyMsg : ECMessageNotifyMsg

/**
 @brief 操作者
 */
@property (nonatomic, copy) NSString* sender;

/**
 @brief 消息时间
 */
@property (nonatomic, copy) NSString* dateCreated;

/**
 @brief 消息id
 */
@property (nonatomic, copy) NSString* messageId;
@end


#pragma mark - 消息撤回通知
/**
 * 消息删除通知
 */
@interface ECMessageRevokeNotifyMsg : ECMessageNotifyMsg

/**
 @brief 会话id
 */
@property (nonatomic, copy) NSString* sessionId;

/**
 @brief 操作者
 */
@property (nonatomic, copy) NSString* sender;

/**
 @brief 消息时间
 */
@property (nonatomic, copy) NSString* dateCreated;

/**
 @brief 消息id
 */
@property (nonatomic, copy) NSString* messageId;
@end

#pragma mark - 消息已读通知
/**
 * 消息已读通知
 */
@interface ECMessageIsReadedNotifyMsg : ECMessageNotifyMsg

/**
 @brief 操作者
 */
@property (nonatomic, copy) NSString* sender;

/**
 @brief 会话id
 */
@property (nonatomic, copy) NSString* sessionId;

/**
 @brief 消息时间
 */
@property (nonatomic, copy) NSString* dateCreated;

/**
 @brief 消息id
 */
@property (nonatomic, copy) NSString* messageId;
@end
