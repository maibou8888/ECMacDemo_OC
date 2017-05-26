//
//  ECAudioConfig.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/1/27.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECEnumDefs.h"

/**
 *  声音配置
 */
@interface ECAudioConfig : NSObject

/**
 @brief 音频设置类型
 */
@property(nonatomic, assign) ECAudioType audioType;

/**
 @brief 是否禁用声音
 */
@property(nonatomic, assign) BOOL enable;

/**
 @brief 声音的类型共有三种，分别是：ECAudioNsMode ECAudioAgcMode ECAudioEcMode
 */
@property(nonatomic, assign) NSInteger audioMode;
@end
