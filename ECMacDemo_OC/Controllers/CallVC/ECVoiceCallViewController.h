//
//  ECVoiceCallViewController.h
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/15.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ECVoiceCallViewController : NSViewController

@property (nonatomic , copy) NSString *callId;
@property (nonatomic , copy) NSString *sessionId;
@property (nonatomic , copy) NSString *videoFlag;

@end
