//
//  ECMessageManager.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/6.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECChatManager.h"
#import "ECGroupManager.h"
#import "ECDeskManager.h"

/**
 * 即时消息管理类
 * 用户发送消息、管理群组、录音、放音等接口
 */
@protocol ECMessageManager <ECChatManager,ECGroupManager,ECDeskManager>

@required
@end
