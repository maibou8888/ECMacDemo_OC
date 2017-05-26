//
//  ECUserStateMessageBody.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 16/3/21.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import "ECMessageBody.h"

@interface ECUserStateMessageBody : ECMessageBody

/**
 @brief userState 状态消息内容 
 0,无状态
 1,写入状态
 2,录音状态
 */
@property (nonatomic, strong) NSString *userState;

/**
 @brief 创建文本实例
 @param userState 状态消息
 */
-(instancetype)initWithUserState:(NSString*)userState;

@end
