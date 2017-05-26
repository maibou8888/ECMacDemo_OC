//
//  ECConferenceDelegate.h
//  CCPiPhoneSDK
//
//  Created by jiazy on 2017/2/13.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECDelegateBase.h"
#import "ECConferenceNotification.h"

@protocol ECConferenceDelegate <ECDelegateBase>

- (void) onReceivedConferenceNotification:(ECConferenceNotification*)info;

@end
