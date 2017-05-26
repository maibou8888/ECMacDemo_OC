//
//  ECLgBottomView.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/19.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECLgBottomView.h"

@implementation ECLgBottomView

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    [[NSColor blueColor] set];
    NSRectFill(dirtyRect);
}

@end
