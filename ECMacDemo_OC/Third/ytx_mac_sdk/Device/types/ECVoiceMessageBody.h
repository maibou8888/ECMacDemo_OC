//
//  ECVoiceMessageBody.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/5/7.
//  Copyright (c) 2015年 ronglian. All rights reserved.
//

#import "ECFileMessageBody.h"

/**
 *  语音消息体
 */
@interface ECVoiceMessageBody : ECFileMessageBody

/**
 @brief 是否正在播放，用于应用使用
 */
@property(nonatomic, assign) BOOL isPlay;

/**
 @brief 语音时长, 秒为单位
 */
@property (nonatomic) NSInteger duration;


/**
 @method
 @brief 以文件路径构造文件对象
 @discussion
 @param filePath 磁盘文件全路径
 @param displayName 文件对象的显示名
 @result 文件对象
 */
- (id)initWithFile:(NSString *)filePath displayName:(NSString *)displayName;

@end
