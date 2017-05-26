//
//  ECVoiceMeetingMsg.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/4/13.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECEnumDefs.h"

#pragma mark - VoIP账号类
/**
 *  VoIP账号类
 */
@interface ECVoIPAccount : NSObject

/**
 @brief 是否是VoIP号
 */
@property (nonatomic, assign) BOOL isVoIP;

/**
 @brief 账号
 */
@property (nonatomic, copy) NSString *account;
@end

#pragma mark - 会议成员基类
/**
 *  会议成员基类
 */
@interface ECMeetingMember : NSObject

/**
 @brief 会议房间的类型
 */
@property (nonatomic, assign) ECMeetingType meetingType;

/**
 @brief 2:创建者 1:参与者
 */
@property (nonatomic, assign) NSInteger role;

@end

#pragma mark - 聊天室成员信息
/**
 *  聊天室成员信息
 */
@interface ECMultiVoiceMeetingMember : ECMeetingMember

/**
 @brief VoIP账号
 */
@property (nonatomic, strong) ECVoIPAccount *account;

/**
 @brief 11：可听可讲 10：可听禁言 01：禁听可讲 00：禁听禁言
 */
@property (nonatomic, copy) NSString *speakListen;
@end

#pragma mark - 对讲成员信息
/**
 *  对讲成员信息
 */
@interface ECInterphoneMeetingMember : ECMeetingMember

/**
 @brief 账号
 */
@property (nonatomic, copy) NSString *number;

/**
 @brief 是否在线 YES:在线
 */
@property (nonatomic, assign) BOOL isOnline;

/**
 @brief 是否控麦 YES:控麦中
 */
@property (nonatomic, assign) BOOL isMic;
@end

#pragma mark - 多路视频会议成员信息
/**
 *  多路视频会议成员信息
 */
@interface ECMultiVideoMeetingMember : ECMeetingMember

/**
 @brief VoIP账号
 */
@property (nonatomic, strong) ECVoIPAccount *voipAccount;

/**
 @brief  视频发布状态 1发布  2未发布
 */
@property (nonatomic, assign) NSInteger videoState;

/**
 @brief  视频源地址 包括ip和端口号
 */
@property (nonatomic, retain) NSString *videoSource;

/**
 @brief 11：可听可讲 10：可听禁言 01：禁听可讲 00：禁听禁言
 */
@property (nonatomic, copy) NSString *speakListen;

@end
