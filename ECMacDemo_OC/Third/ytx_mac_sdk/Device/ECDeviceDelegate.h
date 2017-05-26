//
//  ECDeviceDelegate.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/13.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECDelegateBase.h"
#import "ECNetworkDelegate.h"
#import "ECMessageDelegate.h"
#import "ECDeskDelegate.h"
#import "ECVoIPCallDelegate.h"
#import "ECMeetingDelegate.h"
#import "ECSystemDelegate.h"
#import "ECConferenceDelegate.h"

#ifdef SDK_Ver_LiveStream
#import "ECLiveStreamDelegate.h"
#endif

#ifdef SDK_Ver_WhiteBoard
#import "ECWhiteBoardManager.h"
#endif

/**
 * SDK消息接收代理
 * 设置代理用于接收网络消息、与平台连接消息、接收对方消息等SDK上报的消息；
 */
@protocol ECDeviceDelegate <ECNetworkDelegate,ECMessageDelegate,ECDeskDelegate,ECVoIPCallDelegate,ECMeetingDelegate,ECSystemDelegate,ECConferenceDelegate
#ifdef SDK_Ver_LiveStream
,ECLiveStreamDelegate
#endif
#ifdef SDK_Ver_WhiteBoard
,ECWhiteBoardManager
#endif
>

@required
@end
