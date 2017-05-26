//
//  NSColor+ECColor.h
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/18.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSColor (ECColor)

+ (NSColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;

@end
