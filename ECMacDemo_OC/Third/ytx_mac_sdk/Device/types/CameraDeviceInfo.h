//
//  CameraDeviceInfo.h
//  CCPiPhoneSDK
//
//  Created by wang ming on 15-2-10.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  手机摄像头设备类
 */
@interface CameraDeviceInfo : NSObject

/**
 @brief 摄像头的索引
 */
@property (nonatomic,assign) NSInteger index;

/**
 @brief 摄像头的名称
 */
@property (nonatomic,retain) NSString *name;

/**
 @brief 摄像头数组
 */
@property (nonatomic,retain) NSArray *capabilityArray;
@end

/**
 *  摄像头的信息类
 */
@interface CameraCapabilityInfo : NSObject

/**
 @brief 摄像头的宽度
 */
@property (nonatomic,assign) NSInteger width;

/**
 @brief 摄像头高度
 */
@property (nonatomic,assign) NSInteger height;

/**
 @brief 摄像头的分辨率
 */
@property (nonatomic,assign) NSInteger maxfps;
@end