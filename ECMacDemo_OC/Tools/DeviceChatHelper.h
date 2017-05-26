//
//  DeviceChatHelper.h
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/15.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AudioToolbox/AudioServices.h>

#import "ECFileMessageBody.h"

@interface DeviceChatHelper : NSObject<ECProgressDelegate>

+(DeviceChatHelper*)sharedInstance;

-(ECMessage*)sendTextMessage:(NSString*)text to:(NSString*)to;

-(ECMessage*)sendMediaMessage:(ECFileMessageBody*)mediaBody to:(NSString*)to withUserData:(NSString*)userData;

-(ECMessage*)sendMediaMessage:(ECFileMessageBody*)mediaBody to:(NSString*)to;

-(void)downloadMediaMessage:(ECMessage*)message andCompletion:(void(^)(ECError *error, ECMessage* message))completion;

@end
