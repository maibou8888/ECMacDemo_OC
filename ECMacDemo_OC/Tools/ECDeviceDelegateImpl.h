//
//  ECDeviceDelegateImpl.h
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/3.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECDeviceDelegateImpl : NSObject<ECDeviceDelegate>

@property (nonatomic, copy) NSString *sessionId;

+(ECDeviceDelegateImpl*)sharedInstance;

@end
