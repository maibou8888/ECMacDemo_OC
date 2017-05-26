//
//  ECChatDelegate.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/13.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECDelegateBase.h"
#import "ECMessageNotifyMsg.h"
#import "ECMessage.h"

/**
 * 该代理主要用户接收即时消息和消息的回执报告
 */
@protocol ECChatDelegate <ECDelegateBase>
@optional

/**
 @brief 客户端录音振幅代理函数
 @param amplitude 录音振幅
 */
-(void)onRecordingAmplitude:(double) amplitude;

/**
 @brief 接收即时消息代理函数
 @param message 接收的消息
 */
-(void)onReceiveMessage:(ECMessage*)message;

/**
 @brief 离线消息数
 @param count 消息数
 */
-(void)onOfflineMessageCount:(NSUInteger)count;

/**
 @brief 需要获取的消息数
 @return 消息数 -1:全部获取 0:不获取
 */
-(NSInteger)onGetOfflineMessage;

/**
 @brief 接收离线消息代理函数
 @param message 接收的消息
 */
-(void)onReceiveOfflineMessage:(ECMessage*)message;

/**
 @brief 离线消息接收是否完成
 @param isCompletion YES:拉取完成 NO:拉取未完成(拉取消息失败)
 */
-(void)onReceiveOfflineCompletion:(BOOL)isCompletion;

/**
 @brief 消息操作通知
 @param message 通知消息
 */
-(void)onReceiveMessageNotify:(ECMessageNotifyMsg*)message;

@required

@end
