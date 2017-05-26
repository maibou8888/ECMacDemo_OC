//
//  ECLiveStreamManager.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 2016/11/7.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <UIKit/UIKit.h>
#else
#import <AppKit/AppKit.h>
#endif

@protocol ECLiveStreamManager<NSObject>

/**
 @brief 创建直播流
 @param type 类型。必须为0
 @return 直播流的唯一标识，用于之后的播放等使用，必须大于0
 */
-(NSInteger)createLiveStream:(NSInteger)type;

#if TARGET_OS_IPHONE
/**
 @brief 开始观看直播
 @param liveStreamID 直播流的唯一标识
 @param url 直播地址
 @param view 视频窗口
 @return 0：成功  -1：初始化资源失败 -2：已经在直播或推流  -3：连接失败  -4：建立流失败
 */
-(NSInteger)playLiveStream:(NSInteger)liveStreamID url:(NSString*)url liveStreamView:(UIView*)view;

/**
 @brief 开始直播推流
 @param liveStreamID 直播流的唯一标识
 @param url 推流地址
 @param view 视频窗口
 @return 0：成功  -1：初始化资源失败 -2：已经在直播或推流  -3：连接失败  -4：建立流失败
 */
-(NSInteger)pushLiveStream:(NSInteger)liveStreamID url:(NSString*)url liveStreamView:(UIView*)view;
#elif TARGET_OS_MAC
-(NSInteger)playLiveStream:(NSInteger)liveStreamID url:(NSString*)url liveStreamView:(NSView*)view;
-(NSInteger)pushLiveStream:(NSInteger)liveStreamID url:(NSString*)url liveStreamView:(NSView*)view;
#endif

/**
 @brief 停止观看或推流
 @param liveStreamID 直播流的唯一标识
 @return 0成功；非0失败
 */
-(NSInteger)stopLiveStream:(NSInteger)liveStreamID;

/**
 @brief 释放直播模块
 @param liveStreamID 直播流的唯一标识
 @return 0成功；非0失败
 */
-(NSInteger)releaseLiveStream:(NSInteger)liveStreamID;

/**
 @brief 设置推流视频参数
 @param liveStreamID 直播流的唯一标识
 @param cameraIndex 摄像头index
 @param capabilityIndex 视频能力index
 @return 0：成功　-1：参数不正确
 */
-(NSInteger)setVideoProfileLiveStream:(NSInteger)liveStreamID camera:(NSInteger)cameraIndex capability:(NSInteger)capabilityIndex;

/**
 @brief 设置推流美颜
 @param liveStreamID 直播流的唯一标识
 @param enable 是否开启
 @return 0：成功　其他失败
 */
-(NSInteger)setLiveStream:(NSInteger)handle beauty:(BOOL)enable;
@end
