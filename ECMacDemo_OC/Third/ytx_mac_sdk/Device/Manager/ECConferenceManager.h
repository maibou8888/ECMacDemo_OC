//
//  ECConferenceManager.h
//  CCPiPhoneSDK
//
//  Created by jiazy on 2017/2/13.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif
#import "ECError.h"
#import "ECManagerBase.h"
#import "ECConferenceInfo.h"
#import "ECConferenceCondition.h"
#import "ECConferenceMemberInfo.h"
#import "ECConferenceJoinInfo.h"
#import "ECConferenceVideoInfo.h"

typedef NS_ENUM(NSUInteger,ECControlMediaAction) {
    
    /** 禁听 */
    ECControlMediaAction_CloseListen = 0,
    
    /** 可听 */
    ECControlMediaAction_OpenListen = 1,
    
    /** 禁言 */
    ECControlMediaAction_CloseSpeak = 2,
    
    /** 可说 */
    ECControlMediaAction_OpenSpeak = 3,
    
    /** 停止观看视频 */
    ECControlMediaAction_CloseLookVideo = 10,
    
    /** 观看视频 */
    ECControlMediaAction_OpenLookVideo = 11,
    
    /** 停止发布视频 */
    ECControlMediaAction_StopPublish = 12,
    
    /** 发布视频 */
    ECControlMediaAction_PublishVideo = 13,
    
    /** 停止观看屏幕共享 */
    ECControlMediaAction_CloseLookScreen =20,
    
    /** 观看屏幕共享 */
    ECControlMediaAction_OpenLookScreen = 21,
    
    /** 关闭共享 */
    ECControlMediaAction_CloseScreen = 22,
    
    /** 打开共享 */
    ECControlMediaAction_OpenScreen = 23,
    
    /** 关闭成员的白板共享收看 */
    ECControlMediaAction_StopLookBoard   = 30,
    
    /** 打开议成员的白板共享收看 */
    ECControlMediaAction_OpenLookBoard   = 31,
    
    /** 停止议成员的白板共享 */
    ECControlMediaAction_StopShareBoard  = 32,
    
    /** 开始议成员的白板共享 */
    ECControlMediaAction_OpenShareBoard  = 33,
    
    /** 禁止成员操作白板 */
    ECControlMediaAction_ForbidOperBoard = 34,
    
    /** 允许成员操作白板 */
    ECControlMediaAction_AllowOperBoard  = 35,
};

typedef NS_ENUM(NSUInteger,ECRecordAction) {
    
    /** 开始录音语音 */
    ECRecordAction_RecordSound = 0,
    
    /** 停止录音语音 */
    ECRecordAction_StopSound = 1,
    
    /** 开始录制摄像头视频 */
    ECControlMediaAction_RecordCameraVideo = 10,
    
    /** 停止录制摄像头视频 */
    ECControlMediaAction_StopCameraVideo = 11,
    
    /** 开始录制共享屏幕 */
    ECControlMediaAction_RecordScreenVideo =20,
    
    /** 停止录制共享屏幕 */
    ECControlMediaAction_StopScreenVideo = 21,
    
    /** 开始录制白板 */
    ECControlMediaAction_StartRecordBoard = 30,
    
    /** 停止录制白板 */
    ECControlMediaAction_StopRecordBoard = 31,
    
    /** 开始录制所有 */
    ECControlMediaAction_StartRecordAll = 40,
    
    /** 停止录制所有 */
    ECControlMediaAction_StopRecordAll = 41,
    
};

typedef NS_ENUM(NSUInteger,ECPlayAction) {
    
    /** 开始放音 */
    ECPlayAction_PlayAudio = 0,
    
    /** 停止放音 */
    ECPlayAction_StopAudio = 1,
};

/**
 * 会议管理类_V2
 * 用于创建、解散、会议成员管理等
 */
@protocol ECConferenceManager <ECManagerBase>

/**
 @brief 创建会议
 @param conferenceInfo 会议类
 @param completion 执行结果回调block
 */
- (void)createConference:(ECConferenceInfo*)conferenceInfo completion:(void(^)(ECError* error, ECConferenceInfo*conferenceInfo))completion;

/**
 @brief 删除会议
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)deleteConference:(NSString*)confId completion:(void(^)(ECError* error))completion;

/**
 @brief 更新会议信息
 @param conferenceInfo 会议类
 @param completion 执行结果回调block
 */
- (void)updateConference:(ECConferenceInfo*)conferenceInfo completion:(void(^)(ECError* error))completion;

/**
 @brief 获取会议信息
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)getConference:(NSString*)confId completion:(void(^)(ECError* error, ECConferenceInfo*conferenceInfo))completion;

/**
 @brief 获取会议列表
 @param condition 筛选条件
 @param page 分页信息
 @param completion 执行结果回调block
 */
- (void)getConferenceListWithCondition:(ECConferenceCondition*)condition page:(CGPage)page completion:(void(^)(ECError* error, NSArray* conferenceList))completion;

/**
 @brief 加入会议
 @param joinInfo 加入条件
 @param completion 执行结果回调block
 */
- (void)joinConferenceWith:(ECConferenceJoinInfo*)joinInfo completion:(void(^)(ECError* error))completion;

/**
 @brief 退出会议
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)quitConference:(NSString*)confId completion:(void(^)(ECError* error))completion;

/**
 @brief 更换成员信息
 @param memberInfo 成员信息
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)updateMember:(ECConferenceMemberInfo*)memberInfo ofConference:(NSString*)confId completion:(void(^)(ECError* error))completion;

/**
 @brief 获取成员信息
 @param member 账号信息
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)getMember:(ECAccountInfo*)member ofConference:(NSString*)confId completion:(void(^)(ECError* error, ECConferenceMemberInfo* memberInfo))completion;

/**
 @brief 获取成员列表
 @param confId 会议ID
 @param page 分页信息
 @param completion 执行结果回调block
 */
- (void)getMemberListOfConference:(NSString*)confId page:(CGPage)page completion:(void(^)(ECError* error, NSArray* members))completion;

/**
 @brief 邀请加入会议
 @param inviteMembers ECAccountInfo数组 邀请的成员
 @param confId 会议ID
 @param displayNumber 显示号码
 @param appData 预留
 @param completion 执行结果回调block
 */
- (void)inviteMembers:(NSArray*)inviteMembers inConference:(NSString*)confId displayNumber:(NSString*)displayNumber appData:(NSString*)appData completion:(void(^)(ECError* error))completion;

/**
 @brief 踢出成员
 @param kickMembers ECAccountInfo数组 踢出的成员
 @param confId 会议ID
 @param appData 预留
 @param completion 执行结果回调block
 */
- (void)kickMembers:(NSArray*)kickMembers outConference:(NSString*)confId appData:(NSString*)appData completion:(void(^)(ECError* error))completion;

/**
 @brief 媒体控制
 @param action 控制动作
 @param members ECAccountInfo数组 控制成员列表
 @param isAllMember 是否全部成员
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)controlMedia:(ECControlMediaAction)action toMembers:(NSArray*)members isAll:(BOOL)isAllMember ofConference:(NSString*)confId completion:(void(^)(ECError* error))completion;

/**
 @brief 会议录制
 @param action 录制控制
 @param members ECAccountInfo数组 成员列表
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)record:(ECRecordAction)action members:(NSArray*)members ofConference:(NSString*)confId completion:(void(^)(ECError* error))completion;

/**
 @brief 发布音频
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)publishVoiceInConference:(NSString*)confId completion:(void(^)(ECError* error))completion;

/**
 @brief 取消发布
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)stopVoiceInConference:(NSString*)confId completion:(void(^)(ECError* error))completion;

/**
 @brief 发布视频
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)publishVideoInConference:(NSString*)confId completion:(void(^)(ECError* error))completion;

/**
 @brief 取消发布
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)cancelVideoInConference:(NSString*)confId completion:(void(^)(ECError* error))completion;

/**
 @brief 共享屏幕
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)shareScreenInConference:(NSString*)confId completion:(void(^)(ECError* error))completion;

/**
 @brief 停止共享屏幕
 @param confId 会议ID
 @param completion 执行结果回调block
 */
- (void)stopScreenInConference:(NSString*)confId completion:(void(^)(ECError* error))completion;

/**
 @brief 请求成员视频
 @param videoInfo 视频信息
 @param completion 执行结果回调block
 */
- (void)requestMemberVideoWith:(ECConferenceVideoInfo*)videoInfo completion:(void(^)(ECError* error))completion;

/**
 @brief 停止成员视频
 @param videoInfo 视频信息
 @param completion 执行结果回调block
 */
- (void)stopMemberVideoWith:(ECConferenceVideoInfo*)videoInfo completion:(void(^)(ECError* error))completion;

/**
 @brief 重置显示View
 @param videoInfo 视频信息
 @param completion 执行结果回调block
 */
- (int)resetMemberVideoWith:(ECConferenceVideoInfo*)videoInfo;

- (int)requestMemberVideoSSRCWith:(ECConferenceVideoInfo*)videoInfo;

- (int)stopMemberVideoSSRCWith:(ECConferenceVideoInfo*)videoInfo;

- (int)resetMemberVideoSSRCWith:(ECConferenceVideoInfo*)videoInfo;
@end
