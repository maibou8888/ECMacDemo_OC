//
//  ECTextField.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/18.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECTextField.h"

@interface ECTextField ()<NSTextFieldDelegate>
@property (nullable, copy) NSString *placeStr;
@end

@implementation ECTextField
- (instancetype)init {
    self = [super init];
    if (self) {
        self.bezelStyle = NSTextFieldRoundedBezel;
        self.bordered = NO;
        self.focusRingType = NSFocusRingTypeNone;
        self.font = [NSFont systemFontOfSize:15.0f];
        self.delegate =self;
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect rect = CGRectMake(0, dirtyRect.size.height-10, dirtyRect.size.width, 1);
    NSBezierPath *path = [NSBezierPath bezierPathWithRect:rect];
    [EC_RGB_String(@"#d9dcde") set];
    [path fill];
}

- (BOOL)becomeFirstResponder {
    if (self.placeholderString.length>0 && EC_MAC_OS_X_10_10) {
        self.placeStr = self.placeholderString;
        self.placeholderString = @"";
    }
    return [super becomeFirstResponder];
}
@end
