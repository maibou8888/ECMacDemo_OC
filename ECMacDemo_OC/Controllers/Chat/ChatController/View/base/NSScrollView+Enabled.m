//
//  NSScrollView+Enabled.m
//  DingDing_Project
//
//  Created by hanxiaoqing on 2016/10/24.
//  Copyright © 2016年 HXQ. All rights reserved.
//

#import "NSScrollView+Enabled.h"
#import <objc/runtime.h>

@implementation NSScrollView (Enabled)

+ (void)exchangeInstanceMethod1:(SEL)method1 method2:(SEL)method2
{
    method_exchangeImplementations(class_getInstanceMethod(self, method1), class_getInstanceMethod(self, method2));
}

+ (void)load
{
    [self exchangeInstanceMethod1:@selector(scrollWheel:) method2:@selector(hx_scrollWheel:)];
}

- (void)hx_scrollWheel:(NSEvent *)theEvent {
    if (self.disableScroller) {
        [self.nextResponder scrollWheel:theEvent];
    } else {
        [self hx_scrollWheel:theEvent];
    }
}

static const char scrollEnableKey = '\0';

- (void)setDisableScroller:(BOOL)disableScroller {
    if (disableScroller != self.disableScroller) {
        objc_setAssociatedObject(self, &scrollEnableKey,
                                 @(disableScroller), OBJC_ASSOCIATION_ASSIGN);
    }
}

- (BOOL)disableScroller {
      return [objc_getAssociatedObject(self, &scrollEnableKey) boolValue];
}




@end
