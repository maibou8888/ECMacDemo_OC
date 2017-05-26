//
//  ECMessageManager.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/6.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECCreateMeetingParams.h"
#import "ECEnumDefs.h"

/**
 * 会议管理类
 * 用于创建、解散、会议成员管理等
 */
@protocol ECMeetingManager <ECManagerBase>

/**
 @brief 创建音频会议、视频会议回调
 @param params     会议类
 @param completion 执行结果回调block
 */
-(void)createMultMeetingByType:(ECCreateMeetingParams *)params completion:(void(^)(ECError* error, NSString *meetingNumber))completion;

/**
 @brief 加入音频会议、视频会议、实时对讲
 @param meetingNumber 房间号
 @param meetingType   会议房间的类型
 @param meetingPwd    房间密码
 @param completion    执行结果回调block
 */
-(void)joinMeeting:(NSString*)meetingNumber ByMeetingType:(ECMeetingType )meetingType andMeetingPwd:(NSString *)meetingPwd completion:(void(^)(ECError* error, NSString *meetingNumber))completion;

/**
 @brief 邀请成员加入音频会议
 @param meetingNumber 房间号
 @param isLoadingCall 用户登录的是手机号或者VoIP号，YES是手机号，NO是VoIP号
 @param members       加入房间的成员
 @param completion    执行结果回调block
 */
-(void)inviteMembersJoinToVoiceMeeting:(NSString *)meetingNumber andIsLoandingCall:(BOOL)isLoadingCall andMembers:(NSArray *)members completion:(void(^)(ECError *error ,NSString * meetingNumber))completion EC_DEPRECATED_IOS(5.1.4, 5.1.5, "Use - inviteMembersJoinMultiMediaMeeting:andIsLoandingCall:andMembers:completion:");

/**
 @brief 邀请成员加入音频会议、视频会议
 @param meetingNumber 房间号
 @param isLoadingCall 用户登录的是手机号或者VoIP号，YES是手机号，NO是VoIP号
 @param members       加入房间的成员
 @param completion    执行结果回调block
 */
-(void)inviteMembersJoinMultiMediaMeeting:(NSString *)meetingNumber andIsLoandingCall:(BOOL)isLoadingCall andMembers:(NSArray *)members completion:(void(^)(ECError *error ,NSString * meetingNumber))completion EC_DEPRECATED_IOS(5.1.6, 5.2.0, "Use - inviteMembersJoinMultiMediaMeeting:andIsLoandingCall:andMembers:andDisplayNumber:andSDKUserData:andServiceUserData:completion:");

/**
 @brief 邀请成员加入音频会议、视频会议
 @param meetingNumber 房间号
 @param isLoadingCall 用户登录的是手机号或者VoIP号，YES是手机号，NO是VoIP号
 @param members       加入房间的成员
 @param displaynumber 邀请非VoIP成员显示的号码
 @param sdkUserData   邀请VoIP成员，透传自定义数据
 @param serviceUserData 预留字段
 @param completion    执行结果回调block
 */
- (void)inviteMembersJoinMultiMediaMeeting:(NSString *)meetingNumber andIsLoandingCall:(BOOL)isLoadingCall andMembers:(NSArray *)members andDisplayNumber:(NSString*)displaynumber andSDKUserData:(NSString*)sdkUserData andServiceUserData:(NSString*)serviceUserData completion:(void (^)(ECError *error ,NSString * meetingNumber))completion;

/**
 @brief 邀请成员加入音频会议、视频会议
 @param meetingNumber 房间号
 @param isLoadingCall 用户登录的是手机号或者VoIP号，YES是手机号，NO是VoIP号
 @param members       加入房间的成员
 @param isSpeak       邀请加入的成员是否可讲
 @param isListen      邀请加入的成员是否可听
 @param displaynumber 邀请非VoIP成员显示的号码
 @param sdkUserData   邀请VoIP成员，透传自定义数据
 @param serviceUserData 预留字段
 @param completion    执行结果回调block
 */
- (void)inviteMembersJoinMultiMediaMeeting:(NSString *)meetingNumber andIsLoandingCall:(BOOL)isLoadingCall andMembers:(NSArray *)members andSpeak:(BOOL)isSpeak andListen:(BOOL)isListen andDisplayNumber:(NSString*)displaynumber andSDKUserData:(NSString*)sdkUserData andServiceUserData:(NSString*)serviceUserData completion:(void (^)(ECError *, NSString *))completion;
/**
 @brief 退出音频会议、实时对讲、视频会议
 @return YES 成功; NO 失败
 */
-(BOOL)exitMeeting;

/**
 @brief 解散音频会议、视频会议
 @param multMeetingType 会议房间的类型
 @param meetingNumber   房间号
 @param completion      执行结果回调block
 */
-(void)deleteMultMeetingByMeetingType:(ECMeetingType)multMeetingType andMeetingNumber:(NSString *)meetingNumber completion:(void(^)(ECError *error, NSString *meetingNumber))completion;

/**
 @brief 获取实时对讲、音频会议、视频会议成员列表
 @param meetingtype   会议房间的类型
 @param meetingNumber 房间号
 @param completion    执行结果回调block
 */
-(void)queryMeetingMembersByMeetingType:(ECMeetingType)meetingtype andMeetingNumber:(NSString *)meetingNumber completion:(void(^)(ECError *error, NSArray* members))completion;

/**
 @brief 踢人音频会议、视频会议
 @param multMeetingType 会议房间的类型
 @param meetingNumber   房间号
 @param memberVoip     成员viop号
 @param completion      执行结果回调block
 */
-(void)removeMemberFromMultMeetingByMeetingType:(ECMeetingType)multMeetingType andMeetingNumber:(NSString *)meetingNumber andMember:(ECVoIPAccount *)memberVoip completion:(void(^)(ECError *error, ECVoIPAccount *memberVoip))completion;

/**
 @brief 获取音频会议、视频会议列表
 @param multMeetingType 会议房间的类型
 @param keywords        房间密码
 @param completion      执行结果回调block
 */
-(void)listAllMultMeetingsByMeetingType:(ECMeetingType)multMeetingType andKeywords:(NSString *)keywords completion:(void(^)(ECError *error, NSArray * meetingList))completion;

/**
 @brief 创建实时对讲
 @param members    成员
 @param completion 执行结果回调block
 */
-(void)createInterphoneMeetingWithMembers:(NSArray *)members completion:(void(^)(ECError* error, NSString* meetingNumber))completion   EC_DEPRECATED_IOS(5.1.5, 5.2.2,"Use -createInterphoneMeetingWithMembers:andVoiceMode:completion:");

/**
 @brief 创建实时对讲
 @param members    成员
 @param voiceMode  1：无提示音有背景音；2：有提示音有背景音；3：无提示音无背景音；
 @param completion 执行结果回调block
 */

-(void)createInterphoneMeetingWithMembers:(NSArray *)members andVoiceMode:(NSInteger)voiceMode completion:(void(^)(ECError* error, NSString* meetingNumber))completion;

/**
 @brief 实时对讲进行控麦
 @param meetingNumber 房间号
 @param completion    执行结果回调block
 */
-(void)controlMicInInterphoneMeeting:(NSString*)meetingNumber completion:(void(^)(ECError *error, NSString* memberVoip))completion;

/**
 @brief 实时对讲放麦
 @param meetingNumber 房间号
 @param completion    执行结果回调block
 */
-(void)releaseMicInInterphoneMeeting:(NSString*)meetingNumber completion:(void(^)(ECError *error,NSString *memberVoip))completion;

/**
 @brief 视频会议发布自己的视频
 @param meetingNumber 房间号
 @param completion    执行结果回调block
 */
-(void)publishSelfVideoFrameInVideoMeeting:(NSString *)meetingNumber completion:(void(^)(ECError *error, NSString *meetingNumber))completion;

/**
 @brief 视频会议取消自己的视频
 @param meetingNumber 房间号
 @param completion    执行结果回调block
 */
-(void)cancelPublishSelfVideoFrameInVideoMeeting:(NSString *)meetingNumber completion:(void(^)(ECError *error, NSString *meetingNumber))completion;

/**
 @brief 视频会议请求某一远端视频
 @param username 用户账号
 @param displayView 显示的view
 @param meetingNumber 房间号
 @param meetingPwd 房间密码
 @param port 视频源端口
 @param completion    执行结果回调block
 */
#if TARGET_OS_IPHONE
- (void)requestMemberVideoWithAccount:(NSString*)username andDisplayView:(UIView*)displayView andVideoMeeting:(NSString*)meetingNumber andPwd:(NSString*)meetingPwd andPort:(NSInteger)port completion:(void (^)(ECError *error, NSString *meetingNumber,NSString *member))completion EC_DEPRECATED_IOS(5.1.5, 5.3.0,"Use -requestMemberVideoWithAccount:andDisplayView:andVideoMeeting:andPwd:andIP:andPort:completion:");

- (void)requestMemberVideoWithAccount:(NSString*)username andDisplayView:(UIView*)displayView andVideoMeeting:(NSString*)meetingNumber andPwd:(NSString*)meetingPwd andIP:(NSString*)ip andPort:(NSInteger)port completion:(void (^)(ECError *error, NSString *meetingNumber,NSString *member))completion;
#elif TARGET_OS_MAC
- (void)requestMemberVideoWithAccount:(NSString*)username andDisplayView:(NSView*)displayView andVideoMeeting:(NSString*)meetingNumber andPwd:(NSString*)meetingPwd andPort:(NSInteger)port completion:(void (^)(ECError *error, NSString *meetingNumber,NSString *member))completion EC_DEPRECATED_IOS(5.1.5, 5.3.0,"Use -requestMemberVideoWithAccount:andDisplayView:andVideoMeeting:andPwd:andIP:andPort:completion:");

- (void)requestMemberVideoWithAccount:(NSString*)username andDisplayView:(NSView*)displayView andVideoMeeting:(NSString*)meetingNumber andPwd:(NSString*)meetingPwd andIP:(NSString*)ip andPort:(NSInteger)port completion:(void (^)(ECError *error, NSString *meetingNumber,NSString *member))completion;
#endif

/**
 @brief 视频会议取消请求某一远端视频
 @param username 用户账号
 @param meetingNumber 房间号
 @param meetingPwd 房间密码
 @param completion    执行结果回调block
 */
- (void)cancelMemberVideoWithAccount:(NSString*)username andVideoMeeting:(NSString*)meetingNumber andPwd:(NSString*)meetingPwd completion:(void(^)(ECError *error, NSString *meetingNumber, NSString *member))completion EC_DEPRECATED_IOS(5.1.5, 5.3.0,"Use -cancelMemberVideoWithAccount:andVideoMeeting:andPwd:andIP:andPort:completion:");

- (void)cancelMemberVideoWithAccount:(NSString*)username andVideoMeeting:(NSString*)meetingNumber andPwd:(NSString*)meetingPwd andIP:(NSString*)ip andPort:(NSInteger)port completion:(void(^)(ECError *error, NSString *meetingNumber, NSString *member))completion;

/**
 @brief 设置会议地址
 @param addr 视频会议源地址
 @return 0:成功 非0失败
 */
- (NSInteger)setVideoConferenceAddr:(NSString*)addr EC_DEPRECATED_IOS(5.1.5, 5.3.0);

/**
 @brief 设置会议某成员是否可听可讲
 @param memberVoip    成员viop号
 @param speakListen   是否可听可讲
 @param meetingType   会议房间的类型
 @param meetingNumber 房间号
 @param completion    执行结果回调block
 */
- (void)setMember:(ECVoIPAccount *)memberVoip speakListen:(NSInteger)speakListen ofMeetingType:(ECMeetingType)meetingType andMeetingNumber:(NSString*)meetingNumber completion:(void(^)(ECError *error, NSString *meetingNumber))completion;

@end
