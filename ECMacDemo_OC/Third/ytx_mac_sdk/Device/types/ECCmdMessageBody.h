//
//  ECCmdMessageBody.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 16/8/11.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import "ECMessageBody.h"

/**
 * 离线消息类型
 */
typedef NS_ENUM(NSInteger, ECOfflinePush) {
    
    /** 离线推送 */
    ECOfflinePush_On = 1,
    
    /** 不走离线推送 */
    ECOfflinePush_Off = 2,
    
    /** 不走离线推送，且用户不在线返回错误码570113 */
    ECOfflinePush_OffReturn = 3
};

@interface ECCmdMessageBody : ECMessageBody

/**
 @brief text 文本消息体的内部文本对象的文本
 */
@property (nonatomic, strong) NSString *text;

/**
 @brief isSave 是否存储该消息
 */
@property (nonatomic, assign) BOOL isSave;

/**
 @brief isHint 消息是否提示
 */
@property (nonatomic, assign) BOOL isHint;

/**
 @brief isSyncMsg 是否多设备同步
 */
@property (nonatomic, assign) BOOL isSyncMsg;

/**
 @brief text 是否离线推送
 */
@property (nonatomic, assign) ECOfflinePush offlinePush;

/**
 @brief 创建文本实例
 @param text 文本消息
 */
-(instancetype)initWithText:(NSString*)text;

@end
