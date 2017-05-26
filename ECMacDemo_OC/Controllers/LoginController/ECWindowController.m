//
//  ECWindowController.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/18.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECWindowController.h"


@interface ECWindowController ()

@end

@implementation ECWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    [self.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
    [self.window makeFirstResponder:nil];
    self.window.title = @"";
    self.window.backgroundColor = [NSColor whiteColor];
    [self.window center];

    if(EC_MAC_OS_X_10_10)
        self.window.titlebarAppearsTransparent = YES;
    [AppDelegate shareInstanced].window = self.window;
}

@end
