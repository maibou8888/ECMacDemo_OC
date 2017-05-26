//
//  ECVoIPSetManager.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/1/26.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif
#import "ECManagerBase.h"
#import "ECAudioConfig.h"
#import "NetworkStatistic.h"

typedef NS_ENUM(NSUInteger,ECSrtpCryptoType)  {
    ECSrtpCryptoType_AES_128_SHA1_80 = 1,
    ECSrtpCryptoType_AES_128_SHA1_32 = 2,
    ECSrtpCryptoType_AES_256_SHA1_80 = 3,
    ECSrtpCryptoType_AES_256_SHA1_32 = 4,
};

@protocol ECVoIPSetManager<ECManagerBase>

#pragma mark - 基本设置函数

/**
 @brief 静音设置
 @param on NO:正常 YES:静音
 */
- (NSInteger)setMute:(BOOL)on;

/**
 @brief 获取当前静音状态
 @return NO:正常 YES:静音
 */
- (BOOL)getMuteStatus;

/**
 @brief 获取当前免提状态
 @return NO:关闭 YES:打开
 */
- (BOOL)getLoudsSpeakerStatus;

/**
 @brief 免提设置
 @param enable NO:关闭 YES:打开
 */
- (NSInteger)enableLoudsSpeaker:(BOOL)enable;

/**
 @brief 设置电话
 @param phoneNumber 电话号
 */
- (void)setSelfPhoneNumber:(NSString *)phoneNumber;

/**
 @brief 设置voip通话个人信息
 @param voipCallUserInfo VoipCallUserInfo对象
 */
- (void)setVoipCallUserInfo:(VoIPCallUserInfo *)voipCallUserInfo;

/**
 @brief 设置视频通话显示的view
 @param view 对方显示视图
 @param localView 本地显示视图
 */
#if TARGET_OS_IPHONE
- (NSInteger)setVideoView:(UIView*)view andLocalView:(UIView*)localView;
#elif TARGET_OS_MAC
- (NSInteger)setVideoView:(NSView*)view andLocalView:(NSView*)localView;
#endif

/**
 @brief 重新设置当前视频通话显示的view
 @param view 对方显示视图
 @param localView 本地显示视图
 @param callid 当前视频会话id
 */
#if TARGET_OS_IPHONE
- (NSInteger)resetVideoView:(UIView*)view andLocalView:(UIView*)localView ofCallId:(NSString*)callid;
#elif TARGET_OS_MAC
- (NSInteger)resetVideoView:(NSView*)view andLocalView:(NSView*)localView ofCallId:(NSString*)callid;
#endif


/**
 @brief 获取摄像设备信息
 @return 摄像设备信息数组
 */
- (NSArray*)getCameraInfo;

/**
 @brief 选择使用的摄像设备
 @param cameraIndex 设备index
 @param capabilityIndex 能力index
 @param fps 帧率
 @param rotate 旋转的角度
 */
- (NSInteger)selectCamera:(NSInteger)cameraIndex capability:(NSInteger)capabilityIndex fps:(NSInteger)fps rotate:(ECRotate)rotate;

/**
 @brief 设置支持的编解码方式，默认全部都支持
 @param codec 编解码类型
 @param enabled NO:不支持 YES:支持
 */
-(void)setCodecEnabledWithCodec:(ECCodec)codec andEnabled:(BOOL)enabled;

/**
 @brief 获取编解码方式是否支持
 @param codec 编解码类型
 @return NO:不支持 YES:支持
 */
-(BOOL)getCondecEnabelWithCodec:(ECCodec)codec;

/**
 @brief  设置客户端标示
 @param agent 客服账号
 */
- (void)setUserAgent:(NSString *)agent;

/**
 @brief 设置音频处理的开关,在呼叫前调用
 @param type  音频处理类型. enum AUDIO_TYPE { AUDIO_AGC, AUDIO_EC, AUDIO_NS };
 @param enabled YES：开启，NO：关闭；AGC默认关闭; EC和NS默认开启.
 @param mode: 各自对应的模式: AUDIO_AgcMode、AUDIO_EcMode、AUDIO_NsMode.
 @return  成功 0 失败 -1
 */
-(NSInteger)setAudioConfigEnabledWithType:(ECAudioType)type andEnabled:(BOOL)enabled andMode:(NSInteger)mode;

/**
 @brief 获取音频处理的开关
 @param type  音频处理类型. enum AUDIO_TYPE { AUDIO_AGC, AUDIO_EC, AUDIO_NS };
 @return  成功：音频属性结构 失败：nil
 */
-(ECAudioConfig*)getAudioConfigEnabelWithType:(ECAudioType)type;

/**
 @brief 设置视频通话码率
 @param bitrates  视频码流，kb/s，范围30-300
 */
-(void)setVideoBitRates:(NSInteger)bitrates;

/**
 @brief 统计通话质量
 @return  返回丢包率等通话质量信息对象
 */
-(CallStatisticsInfo*)getCallStatisticsWithCallid:(NSString*)callid andType:(CallType)type;

/**
 @brief 获取通话的网络流量信息
 @param   callid :  会话ID,会议类传入房间号
 @return  返回网络流量信息对象
 */
- (NetworkStatistic*)getNetworkStatisticWithCallId:(NSString*)callid;

/**
 @brief 通话过程中设置本端摄像头开启关闭，自己能看到对方，通话对方看不到自己。
 @param callid:会话ID
 @param on:是否开启
 @return 是否成功 0：成功； 非0失败
 */
- (NSInteger)setLocalCameraOfCallId:(NSString*)callid andEnable:(BOOL)enable;

/**
 @brief 远程快照
 @param callid:当前呼叫的唯一标识.
 @param fileName:快照文件保存的全路径，含后缀名.jpg
 @return 是否成功 0：成功； 非0失败
 */
- (NSInteger)saveRemoteVideoSnapshot:(NSString*)callid fileName:(NSString*)fileName;

/**
 @brief 本地快照
 @param callid:当前呼叫的唯一标识.
 @param fileName:快照文件保存的全路径，含后缀名.jpg
 @return 是否成功 0：成功； 非0失败
 */
- (NSInteger)saveLocalVideoSnapshot:(NSString *)callid fileName:(NSString*)fileName;

/**
 @brief 设置重传模式
 @param audio:底层默认1。0关闭，1协商打开，2强制打开
 @param video:底层默认1。0关闭，1协商打开，2强制打开
 @return 是否成功 0：成功； 非0失败
 */
-(void)setCodecNackAudio:(NSInteger)audio video:(NSInteger)video;

/**
 @brief 设置SRTP加密属性
 @param enable:是否开启
 @param type:加密类型
 */
-(void)setSrtpEnabled:(BOOL)enable cryptoType:(ECSrtpCryptoType)type;

/**
 @brief P2P设置
 @param isNatP2P:是否开启
 @return 是否成功 0：成功； 非0失败
 */
- (NSInteger)setNatTraversal:(BOOL)isNatP2P;

/**
 @brief 邀请三方加入
 @param member 第三方账号
 @param callId 会话ID
 @param displayName 显号
 @param completion 执行结果回调block
 */
- (void)inviteThreePart:(NSString*)member join:(NSString*)callId dispalyName:(NSString*)displayName completion:(void(^)(ECError *error))completion;

/**
 @brief 开启服务器录像
 @param callid 会话ID
 @param fileName 录像文件名称
 @param filePath 录像服务器地址
 @param resolution 录像分辨率 720p或1080p
 @param source 录制源，0录制双方、1主叫、2被叫
 @param isMix 是否混屏
 @param url 录制回调URL
 @param completion 执行结果回调block
 */
- (void)startServerRecord:(NSString*)callid fileName:(NSString*)fileName filePath:(NSString*)filePath resolution:(NSString*)resolution source:(NSInteger)source isMixScreen:(BOOL)isMix callBackUrl:(NSString*)url completion:(void(^)(ECError *error))completion;

/**
 @brief 关闭启服务器录像
 @param callid 会话ID
 @param completion 执行结果回调block
 */
- (void)stopServerRecord:(NSString*)callid completion:(void(^)(ECError *error))completion;

/**
 @brief 请求第三方视频
 @param displayView 视频显示view
 @param completion 执行结果回调block
 */
#if TARGET_OS_IPHONE
- (void)requestCurrentThreePartMemberVideo:(UIView*)displayView completion:(void(^)(ECError *error))completion;
#elif TARGET_OS_MAC
- (void)requestCurrentThreePartMemberVideo:(NSView*)displayView completion:(void(^)(ECError *error))completion;
#endif


/**
 @brief 取消第三方视频
 @param completion 执行结果回调block
 */
- (void)cancelCurrentThreePartMemberVideo:(void(^)(ECError *error))completion;

/**
 @brief 转接第三方
 @param callid 会话ID
 @param member 第三方账号
 @param displayNumber 显示号码
 @param completion 执行结果回调block
 */
- (void)transferCall:(NSString*)callid toMember:(NSString*)member displayNumber:(NSString*)displayNumber completion:(void(^)(ECError *error))completion;

/**
 @brief 强拆第三方
 @param callid 会话ID
 @param completion 执行结果回调block
 */
- (void)forceThreePartRelease:(NSString*)callid completion:(void(^)(ECError *error))completion;
@end
