//
//  ECVoiceMeetingMsg.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/4/13.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECEnumDefs.h"

#pragma mark - 会议房间基类
/**
 *  会议房间基类
 */
@interface ECMeetingRoom : NSObject

/**
 @brief 会议房间的类型
 */
@property (nonatomic, assign) ECMeetingType meetingType;

/**
 @brief 聊天室号
 */
@property (nonatomic, copy) NSString *roomNo;

/**
 @brief 聊天室名称
 */
@property (nonatomic, copy) NSString *roomName;

/**
 @brief 聊天室创建者
 */
@property (nonatomic, copy) NSString *creator;

/**
 @brief 参与最多的人数
 */
@property (nonatomic, assign) NSInteger square;

/**
 @brief 聊天室密码
 */
@property (nonatomic, copy) NSString *keywords;

/**
 @brief 加入的成员号
 */
@property (nonatomic, assign) NSInteger joinNum;

/**
 @brief 是否需要密码认证 YES:需要密码认证
 */
@property (nonatomic, assign) BOOL isValidate;
@end

#pragma mark - 聊天室信息类
/**
 *  聊天室信息类
 */
@interface ECMultiVoiceMeetingRoom : ECMeetingRoom


@end

#pragma mark - 多路视频房间信息类
/**
 *  多路视频房间信息类
 */
@interface ECMultiVideoMeetingRoom : ECMeetingRoom


@end
