//
//  NSMutableAttributedString+HXPromote.h
//  DingDing_Project
//
//  Created by hanxiaoqing on 2017/1/16.
//  Copyright © 2017年 HXQ. All rights reserved.
//

#import <AppKit/AppKit.h>
#import <CoreText/CoreText.h>


@interface NSMutableAttributedString (init_)

+ (instancetype)mAttsWithString:(NSString *)string;
+ (instancetype)mAttsWithAttString:(NSAttributedString *)atts;

+ (instancetype)blankMAttStringWithCharSize:(CGSize)cSize baselineOffset:(CGPoint)blOffset;


@end




@interface NSMutableAttributedString (Config_)

// 设置颜色
- (void)setTextColor:(NSColor *)color;
- (void)setTextColor:(NSColor *)color range:(NSRange)range;

// 设置字体
- (void)setFont:(NSFont *)font;
- (void)setFont:(NSFont *)font range:(NSRange)range;

- (void)setLineSpacing:(CGFloat)lineSpacing;

@end



@interface NSMutableAttributedString (AttachMent_)

+ (instancetype)mAttsWithAttachCell:(NSTextAttachmentCell *)attachmentCell;

//+ (instancetype)mAttsWithAttachImage:(NSImage *)aimg charSize:(CGSize)cSize baselineOffset:(CGPoint)blOffset;

@end



@interface NSMutableAttributedString (Calculate_)

- (CGSize)sizeForMaxLayoutWidth:(CGFloat)width;
- (CGSize)sizeForSingleLine;

@end












