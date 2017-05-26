//
//  ECInterphoneMeetingMsg.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/4/13.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - ECMeetingType_Interphone 相关通知类消息
typedef NS_ENUM(NSUInteger, ECInterphoneMeetingMsgType) {
    
    /** 会议通话断开 */
    Interphone_CUT = 99,
    
    /** 邀请加入实时对讲 */
    Interphone_INVITE = 201,
    
    /** 加入实时对讲 */
    Interphone_JOIN = 202,
    
    /** 退出实时对讲 */
    Interphone_EXIT = 203,
    
    /** 结束实时对讲 */
    Interphone_OVER = 204,
    
    /** 控麦 */
    Interphone_CONTROLMIC = 205,
    
    /** 放麦 */
    Interphone_RELEASEMIC = 206
};

@interface ECInterphoneMeetingMsg : NSObject

/**
 @brief 实时对讲机消息类型
 */
@property (nonatomic, assign) ECInterphoneMeetingMsgType type;

/**
 @brief 实时对讲机id
 */
@property (nonatomic, copy) NSString *interphoneId;

/**
 @brief 邀请加入实时对讲时间戳
 */
@property (nonatomic, copy) NSString *dateCreated;

/**
 @brief 邀请者的VoIP号
 */
@property (nonatomic, copy) NSString *fromVoip;

/**
 @brief 有人加入实时对讲的VoIP账号集合
 */
@property (nonatomic, copy) NSArray *joinArr;

/**
 @brief 有人退出实时对讲的VoIP账号集合
 */
@property (nonatomic, copy) NSArray *exitArr;

/**
 @brief 控麦/放麦的VoIP账号
 */
@property (nonatomic, copy) NSString *voip;
@end
