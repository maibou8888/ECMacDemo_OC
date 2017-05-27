//
//  ECSessionCell.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/20.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECSessionCell.h"

@interface ECSessionCell ()
@end

@implementation ECSessionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.offBtn.hidden = YES;
}

- (void)setBackgroundStyle:(NSBackgroundStyle)backgroundStyle {
    [super setBackgroundStyle:backgroundStyle];
    if (backgroundStyle == NSBackgroundStyleDark) {
        self.wantsLayer = YES;
        self.layer.backgroundColor = EC_RGB_String(@"#d5d4d4").CGColor;
    } else {
        self.wantsLayer = YES;
        self.layer.backgroundColor = [NSColor whiteColor].CGColor;
    }
}

- (void)viewDidMoveToWindow {
    [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
}

- (void)mouseEntered:(NSEvent *)event {
    self.offBtn.hidden = NO;
}

- (void)mouseExited:(NSEvent *)event {
    self.offBtn.hidden = YES;
}

@end
