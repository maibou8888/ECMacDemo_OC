//
//  NSImage+StackBlur.h
//  NeteaseMusic
//
//  Created by han on 3/3/15.
//  Copyright (c) 2015 openthread. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSImage (StackBlur)

/**
 图片模糊
 @param inradius 模糊程度
 */
- (NSImage *)stackBlur:(int)inradius;

/**
 剪切圆形图片，且可以带圆形边框

 @param borderWidth 圆形边框宽度
 @param borderColor 圆形边框颜色
 @param size        大小

 @return 剪好的图片
 */
- (NSImage *)circleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(NSColor *)borderColor size:(CGSize)size;


/**
 由NSColor生成一张纯色图片
 @param color 生成纯色图片颜色
 @param size  大小
 */
+ (NSImage *)imageWithColor:(NSColor *)color size:(NSSize)size;


/**
 由NSColor生成一张纯色图片 圆形的
 @param color 生成纯色图片颜色
 @param size  大小
 */
+ (NSImage *)circleImageWithColor:(NSColor *)color size:(NSSize)size;


/**
 由NSColor生成一张纯色图片 圆形的带文字
 @param color 生成纯色图片颜色
 @param size  大小
 @param text  文字
 */
+ (NSImage *)circleImageWithColor:(NSColor *)color size:(NSSize)size text:(NSString *)text;

+ (NSImage *)circleImageWithColor:(NSColor *)color size:(NSSize)size text:(NSString *)text font:(NSFont *)font;

@end
