//
//  ECSountTouchConfig.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/11/17.
//  Copyright © 2015年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  声音配置类
 */
@interface ECSountTouchConfig : NSObject

/**
 @brief 源声音文件
 */
@property (nonatomic, copy) NSString *srcVoice;

/**
 @brief 目标声音文件
 */
@property (nonatomic, copy) NSString *dstVoice;

/**
 @brief 速度 <变速不变调> -50~100
 */
@property (nonatomic, assign) int tempoChange;

/**
 @brief 音调 -12~12
 */
@property (nonatomic, assign) int pitch;

/**
 @brief 声音速率 -50~100
 */
@property (nonatomic, assign) int rate;

@end
