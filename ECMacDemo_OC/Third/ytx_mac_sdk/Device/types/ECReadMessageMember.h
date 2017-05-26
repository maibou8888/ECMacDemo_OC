//
//  ECReadMessageMember.h
//  CCPiPhoneSDK
//
//  Created by huangjue on 16/6/16.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECReadMessageMember : NSObject

/**
 @brief 账号id
 */
@property (nonatomic, copy) NSString *userName;

/**
 @brief 回执时间戳
 */
@property (nonatomic, copy) NSString *timetmp;

@end
