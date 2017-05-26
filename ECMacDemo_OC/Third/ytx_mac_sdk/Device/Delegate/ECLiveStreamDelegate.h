//
//  ECLiveStreamDelegate.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 2016/11/7.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 重连状态值
 */
typedef NS_ENUM(NSUInteger,ECLiveStreamNetStatus) {
    
    /** 连接中 */
    ECLiveStreamNetStatus_CONNECTING=1,
    
    /** 连接成功 */
    ECLiveStreamNetStatus_CONNECTED,
    
    /** 连接断开 */
    ECLiveStreamNetStatus_DISCONNECTED,
    
    /** 连接超时 */
    ECLiveStreamNetStatus_TIMEOUT
};

/**
 * 直播功能回调代理
 */
@protocol ECLiveStreamDelegate<NSObject>
@optional
/**
 @brief 直播连接回调
 @param liveStreamID 直播流的唯一标识
 @param status ECLiveStreamNetState 直播网络状态
 */
-(void) onLiveStream:(NSInteger)liveStreamID networkStatus:(ECLiveStreamNetStatus)status;

/**
 @brief 直播播放分辨率回调
 @param liveStreamID 直播流的唯一标识
 @param width  视频宽度
 @param height 视频高度
 */
-(void) onLiveStreamVideoResolution:(NSInteger)liveStreamID width:(NSInteger)width height:(NSInteger)height;

@end
