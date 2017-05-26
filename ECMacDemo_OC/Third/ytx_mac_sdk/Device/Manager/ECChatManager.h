//
//  ECChatManager.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/6.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "ECManagerBase.h"
#import "ECMessage.h"
#import "ECError.h"
#import "ECProgressDelegate.h"
#import "ECFileMessageBody.h"
#import "ECVoiceMessageBody.h"
#import "ECVideoMessageBody.h"
#import "ECImageMessageBody.h"
#import "ECSountTouchConfig.h"

/**
 * 聊天管理类
 * 用于发送消息、录音、播音、下载附件消息等
 */
@protocol ECChatManager <ECManagerBase>

/**
 @brief 发送消息
 @discussion 发送文本消息时，进度不生效；发送附件消息时，进度代理生效
 @param message 发送的消息
 @param progress 发送进度代理
 @param completion 执行结果回调block
 @return 函数调用成功返回消息id，失败返回nil
 */
-(NSString*)sendMessage:(ECMessage*)message progress:(id<ECProgressDelegate>)progress completion:(void(^)(ECError *error, ECMessage* message))completion;

/**
 @brief 取消发送消息，取消结果在发送消息completion返回错误171259；暂时只支持以下类型：
 MessageBodyType_Voice
 MessageBodyType_Video
 MessageBodyType_Image
 MessageBodyType_File
 MessageBodyType_Preview
 
 @param message 取消发送的消息
 */
-(ECError*)cancelSendMessage:(ECMessage*)message;

/**
 @brief 录制arm音频
 @param msg 音频的消息体
 @param completion 执行结果回调block
 */
-(void)startVoiceRecording:(ECVoiceMessageBody*)msg error:(void(^)(ECError* error, ECVoiceMessageBody *messageBody))error;

/**
 @brief 停止录制arm音频
 @param completion 执行结果回调block
 */
-(void)stopVoiceRecording:(void(^)(ECError *error, ECVoiceMessageBody *messageBody))completion;

/**
 @brief 播放arm音频消息
 @param completion 执行结果回调block
 */
-(void)playVoiceMessage:(ECVoiceMessageBody*)msg completion:(void(^)(ECError *error))completion;

/**
 @brief 停止播放音频
 */
-(BOOL)stopPlayingVoiceMessage;

/**
 @brief 下载附件消息
 @param message 多媒体类型消息
 @param progress 下载进度
 @param completion 执行结果回调block
 */
-(void)downloadMediaMessage:(ECMessage*)message progress:(id<ECProgressDelegate>)progress completion:(void(^)(ECError *error, ECMessage* message))completion;

/**
 @brief 下载图片文件缩略图
 @param message 多媒体类型消息
 @param progress 下载进度
 @param completion 执行结果回调block
 */
-(void)downloadThumbnailMessage:(ECMessage*)message progress:(id<ECProgressDelegate>)progress completion:(void(^)(ECError *error, ECMessage* message))completion;

/**
 @brief 删除点对点消息(目前只支持删除接收到的消息)
 @param message 需要删除的消息
 @param completion 执行结果回调block
 */
-(void)deleteMessage:(ECMessage*)message completion:(void(^)(ECError *error, ECMessage* message)) completion;

/**
 @brief 撤回消息
 @param message 需要撤回的消息
 @param completion 执行结果回调block
 */
-(void)revokeMessage:(ECMessage*)message completion:(void(^)(ECError *error, ECMessage* message)) completion;

/**
 @brief 消息已读（接收到的消息）
 @param message 设置已读的消息
 @param completion 执行结果回调block
 */
-(void)readedMessage:(ECMessage*)message completion:(void(^)(ECError *error, ECMessage* message)) completion;

/**
 @brief 获取消息状态（只支持群组，且发送的消息）
 @param message 设置已读的消息
 @param completion 执行结果回调block
 */
-(void)queryMessageReadStatus:(ECMessage*)message completion:(void(^)(ECError *error, NSArray* readArray, NSArray* unreadArray)) completion EC_DEPRECATED_IOS(5.2.2, 5.2.2);

/**
 @brief 变声操作
 @param dstSoundConfig 目标文件的变化配置
 @param completion 执行结果回调block
 */
-(void)changeVoiceWithSoundConfig:(ECSountTouchConfig*)dstSoundConfig completion:(void(^)(ECError *error, ECSountTouchConfig* dstSoundConfig)) completion;

/**
 @brief 是否置顶会话
 @param seesionId 会话id
 @param isTop 0 取消置顶 1 置顶
 */
-(void)setSession:(NSString*)seesionId IsTop:(BOOL)isTop completion:(void(^)(ECError *error, NSString *seesionId))completion;

/**
 @brief 获取置顶会话列表
 @param completion 执行结果回调block（注：topContactLists为会话seesionId）
 */
- (void)getTopSessionLists:(void(^)(ECError *error, NSArray *topContactLists))completion;

@end
