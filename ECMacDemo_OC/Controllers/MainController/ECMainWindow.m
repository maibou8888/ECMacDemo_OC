//
//  ECMainWindow.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/19.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECMainWindow.h"

@implementation ECMainWindow

- (instancetype)initWithContentRect:(NSRect)contentRect styleMask:(NSWindowStyleMask)style backing:(NSBackingStoreType)bufferingType defer:(BOOL)flag {
    self = [super initWithContentRect:contentRect styleMask:style backing:bufferingType defer:flag];
    if (self) {
        self.backgroundColor = [NSColor whiteColor];
    }
    return self;
}

- (BOOL)canBecomeKeyWindow {
    return YES;
}

- (BOOL)canBecomeMainWindow{
    return YES;
}

@end
