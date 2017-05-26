//
//  ECMainSplitView.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/20.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECMainSplitView.h"

@implementation ECMainSplitView

- (void)awakeFromNib {
    [super awakeFromNib];
    self.dividerStyle = NSSplitViewDividerStyleThin;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}
@end
