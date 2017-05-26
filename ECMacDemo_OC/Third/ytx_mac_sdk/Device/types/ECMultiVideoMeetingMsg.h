//  ECInterphoneMeetingMsg.h
//  CCPiPhoneSDK
//
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECMeetingMember.h"

#pragma mark - ECMeetingType_MultiVoice 相关通知类消息

typedef NS_ENUM(NSUInteger, ECMultiVideoMeetingMsgType) {
    
    /** 会议通话断开 */
    MultiVideo_CUT = 99,
    
    /** 加入聊天室 */
    MultiVideo_JOIN = 601,
    
    /** 退出聊天室 */
    MultiVideo_EXIT = 602,
    
    /** 删除聊天室 */
    MultiVideo_DELETE = 603,
    
    /** 踢出聊天室成员 */
    MultiVideo_REMOVEMEMBER = 604,
    
    /** 是否可听可讲 */
    MultiVideo_SPEAKLISTEN = 606,
    
    /** 发布视频 */
    MultiVideo_PUBLISH = 607,
    
    /** 取消发布视频 */
    MultiVideo_UNPUBLISH = 608,
    
    /** 拒绝 */
    MultiVideo_REFUSE = 609
};

/**
 *  多路视频会议类
 */
@interface ECMultiVideoMeetingMsg : NSObject

/**
 @brief 多路视频会议的消息类型
 */
@property (nonatomic, assign) ECMultiVideoMeetingMsgType type;

/**
 @brief 多路视频会议房间id
 */
@property (nonatomic, copy) NSString *roomNo;

/**
 @brief 有人加入多路视频会议的VoIP号的集合
 */
@property (nonatomic, copy) NSArray *joinArr;

/**
 @brief 有人退出多路视频会议的VoIP号的集合
 */
@property (nonatomic, copy) NSArray *exitArr;

/**
 @brief VoIP账号
 */
@property (nonatomic, strong) ECVoIPAccount *who;

/**
 @brief  视频发布状态 1发布  2未发布
 */
@property (nonatomic, assign) NSInteger videoState;

/**
 @brief  视频源地址 包括ip和端口号
 */
@property (nonatomic, retain) NSString *videoSource;

/**
 @brief 用户拒绝加入会议
 */
@property (nonatomic, copy) NSArray *refuseArr;

/**
 @brief 当前只适用于拒绝原因
 */
@property (nonatomic, assign) NSInteger errorCode;

/**
 @brief 是否禁言 11：可听可讲 10：可听禁言 01：禁听可讲 00：禁听禁言
 */
@property (nonatomic, copy) NSString *speakListen;
@end

