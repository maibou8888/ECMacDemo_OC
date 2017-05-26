//
//  NetworkStatistic.h
//  CCPiPhoneSDK
//
//  Created by wang ming on 15-2-6.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  返回网络流量信息对象
 */
@interface NetworkStatistic:NSObject

/**
 @brief  媒体交互的持续时间，单位秒，可能为0
 */
@property (nonatomic) long long duration;

/**
 @brief  在duration时间内，sim网络发送的总流量，单位字节
 */
@property (nonatomic) long long txBytes_sim;

/**
 @brief  在duration时间内，sim网络接收的总流量，单位字节
 */
@property (nonatomic) long long rxBytes_sim;

/**
 @brief  在duration时间内，wifi网络发送的总流量，单位字节
 */
@property (nonatomic) long long txBytes_wifi;

/**
 @brief  在duration时间内，wifi网络接收的总流量，单位字节
 */
@property (nonatomic) long long rxBytes_wifi;
@end

/**
 *  返回丢包率等通话质量信息对象
 */
@interface CallStatisticsInfo:NSObject

/**
 @brief  上次调用获取统计后这一段时间的丢包率，范围是0~255，255是100%丢失。
 */
@property (nonatomic,assign)   NSUInteger  rlFractionLost;

/**
 @brief  开始通话后的所有的丢包总个数
 */
@property (nonatomic,assign)   NSUInteger  rlCumulativeLost;

/**
 @brief  开始通话后应该收到的包总个数
 */
@property (nonatomic,assign)   NSUInteger  rlExtendedMax;

/**
 @brief  rtp抖动率
 */
@property (nonatomic,assign)   NSUInteger  rlJitterSamples;

/**
 @brief  延迟时间，单位是ms
 */
@property (nonatomic,assign)   NSInteger   rlRttMs;

/**
 @brief  开始通话后发送的总字节数
 */
@property (nonatomic,assign)   NSUInteger  rlBytesSent;

/**
 @brief  开始通话后发送的总RTP包个数
 */
@property (nonatomic,assign)   NSUInteger  rlPacketsSent;

/**
 @brief  开始通话后收到的总字节数
 */
@property (nonatomic,assign)   NSUInteger  rlBytesReceived;

/**
 @brief  开始通话后收到的总RTP包个数
 */
@property (nonatomic,assign)   NSUInteger  rlPacketsReceived;   
@end