//
//  ECMultiDeviceState.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 16/1/21.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECEnumDefs.h"

@interface ECMultiDeviceState : NSObject

/**
 @brief 设备状态
 */
@property (nonatomic, assign) BOOL isOnline;

/**
 @brief 终端类型
 */
@property (nonatomic, assign) ECDeviceType deviceType;

@end
