//
//  ECChatToolView.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/26.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECChatToolView.h"

@implementation ECChatToolView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.layer.borderColor = [NSColor clearColor].CGColor;
    self.wantsLayer = YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

@end
