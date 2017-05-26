//
//  ECConferenceNotification.h
//  CCPiPhoneSDK
//
//  Created by jiazy on 2017/2/21.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECConferenceMemberInfo.h"
#import "ECConferenceManager.h"

typedef NS_ENUM(NSUInteger, ECConferenceNotificationType) {
    
    /** 会议删除 */
    ECConferenceNotificationType_Delete = 1,
    
    /** 成员加入 */
    ECConferenceNotificationType_Join = 2,
    
    /** 成员退出 */
    ECConferenceNotificationType_Quit = 3,
    
    /** 成员被踢出 */
    ECConferenceNotificationType_KickOut = 4,
    
    /** 成员信息更新 */
    ECConferenceNotificationType_MemberInfo = 5,
    
    /** 会议邀请 */
    ECConferenceNotificationType_Invite = 6,
    
    /** 会议信息更新 */
    ECConferenceNotificationType_Update = 17,
    
    /** 媒体被控制 */
    ECConferenceNotificationType_MediaControl = 22,
	    
    /** 会议预约 */
    ECConferenceNotificationType_Subscribe = 24,
};

#pragma mark -
#pragma mark 会议通知基类
/**
 *  会议通知基类
 */
@interface ECConferenceNotification : NSObject

/**
 @brief 通知类型
 */
@property (nonatomic, assign) ECConferenceNotificationType type;

/**
 @brief 会议ID
 */
@property (nonatomic, copy) NSString *conferenceId;

@end


#pragma mark -
#pragma mark 会议删除通知
/**
 *  会议删除通知
 */
@interface ECConferenceDeleteNotification : ECConferenceNotification

@end

#pragma mark -
#pragma mark 会议加入通知
/**
 *  会议加入通知
 */
@interface ECConferenceJoinNotification : ECConferenceNotification

/**
 @brief 加入成员
 */
@property (nonatomic, strong) ECAccountInfo* member;

/**
 @brief 邀请者
 */
@property (nonatomic, strong) ECAccountInfo* inviter;
@end


#pragma mark -
#pragma mark 会议退出通知
/**
 *  会议退出通知
 */
@interface ECConferenceQuitNotification : ECConferenceNotification
/**
 @brief 退出成员
 */
@property (nonatomic, strong) ECAccountInfo* member;
@end


#pragma mark -
#pragma mark 成员被踢通知
/**
 *  成员被踢
 */
@interface ECConferenceKickOutNotification : ECConferenceNotification

/**
 @brief 踢人者
 */
@property (nonatomic, strong) ECAccountInfo* member;

/**
 @brief 被踢成员 ECAccountInfo
 */
@property (nonatomic, strong) NSArray *kickedMembers;

@end

#pragma mark -
#pragma mark 成员更新通知
/**
 *  成员更新通知
 */
@interface ECConferenceMemberInfoNotification : ECConferenceNotification

/**
 @brief 更新类型
 */
@property (nonatomic, assign) ECControlMediaAction action;

/**
 @brief 成员信息 ECConferenceMemberInfo
 */
@property (nonatomic, strong) NSArray *members;

@end

#pragma mark -
#pragma mark 邀请加入通知
/**
 *  邀请加入通知
 */
@interface ECConferenceInviteNotification : ECConferenceNotification

/**
 @brief 邀请者
 */
@property (nonatomic, strong) ECAccountInfo* inviter;

/**
 @brief 会议名称
 */
@property (nonatomic, copy) NSString* confName;

/**
 @brief 会议密码
 */
@property (nonatomic, copy) NSString* password;

/**
 @brief 会议开始时间
 */
@property (nonatomic, copy) NSString* inviteTime;

/**
 @brief 邀请通知的唯一标识
 */
@property (nonatomic, copy) NSString* invitationId;

/**
 @brief 预留字段
 */
@property (nonatomic, copy) NSString* appData;

@end

#pragma mark -
#pragma mark 预约会议通知
/**
 *  邀请加入通知
 */
@interface ECConferenceSubscribeNotification : ECConferenceNotification

/**
 @brief 邀请者
 */
@property (nonatomic, strong) ECAccountInfo* inviter;

/**
 @brief 会议名称
 */
@property (nonatomic, copy) NSString* confName;

/**
 @brief 会议密码
 */
@property (nonatomic, copy) NSString* password;

/**
 @brief 会议开始时间
 */
@property (nonatomic, copy) NSString* startTime;

/**
 @brief 会议持续时间
 */
@property (nonatomic, copy) NSString* duration;

/**
 @brief 预留字段
 */
@property (nonatomic, copy) NSString* appData;

@end

#pragma mark -
#pragma mark 会议更新通知
/**
 *  会议更新通知
 */
@interface ECConferenceUpdateNotification : ECConferenceNotification

/**
 @brief 更新者
 */
@property (nonatomic, strong) ECAccountInfo* member;

/**
 @brief 会议名称
 */
@property (nonatomic, copy) NSString *confName;

/**
 @brief 预留字段
 */
@property (nonatomic, copy) NSString *appData;

@end

#pragma mark -
#pragma mark 媒体被操作通知
/**
 *  媒体被操作通知
 */
@interface ECConferenceMediaControlNotification : ECConferenceNotification

/**
 @brief 操作类型
 */
@property (nonatomic, assign) ECControlMediaAction action;

@end
