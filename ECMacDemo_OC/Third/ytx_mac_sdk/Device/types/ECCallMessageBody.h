//
//  ECCallMessageBody.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 15/11/16.
//  Copyright © 2015年 ronglian. All rights reserved.
//

#import "ECMessageBody.h"
#import "VoipCall.h"

/**
 * 未接来电消息
 */
@interface ECCallMessageBody : ECMessageBody

/**
 @brief callText 呼叫内容
 */
@property (nonatomic, strong) NSString *callText;

/**
 @brief calltype 呼叫类型
 */
@property (nonatomic, assign) CallType calltype;

/**
 @brief 创建未读来电实例
 @param callText 文本消息
 */
-(instancetype)initWithCallText:(NSString*)callText;
@end
