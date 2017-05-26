//
//  ECMessageDelegate.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/13.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECGroupDelegate.h"
#import "ECChatDelegate.h"

/**
 * 该代理用于接收即时消息有关的消息
 */
@protocol ECMessageDelegate <ECChatDelegate, ECGroupDelegate>

@required
@end
