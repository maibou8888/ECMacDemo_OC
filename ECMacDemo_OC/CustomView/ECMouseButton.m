//
//  ECMouseButton.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/27.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECMouseButton.h"

@interface ECMouseButton ()
@property (nonatomic, strong) NSImage *img;
@end

@implementation ECMouseButton

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)viewDidMoveToWindow {
    [self addTrackingRect:[self bounds] owner:self userData:nil assumeInside:NO];
}

- (void)mouseEntered:(NSEvent *)event {
    self.img = self.image;
    self.image = self.alternateImage;
}

- (void)mouseExited:(NSEvent *)event {
    self.image = self.img;
}

@end
