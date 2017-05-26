//
//  NSMutableAttributedString+HXPromote.m
//  DingDing_Project
//
//  Created by hanxiaoqing on 2017/1/16.
//  Copyright © 2017年 HXQ. All rights reserved.
//

#import "NSMutableAttributedString+HXPromote.h"

@implementation NSMutableAttributedString (init_)

+ (instancetype)mAttsWithAttString:(NSAttributedString *)atts
{
    return [[self alloc] initWithAttributedString:atts];
}

+ (instancetype)mAttsWithString:(NSString *)string
{
    return [[self alloc] initWithString:string];
}

static  CGFloat blankW = 0;
static  CGFloat blankH = 0;
static  CGFloat Baseline_OffsetY = 0;

+ (instancetype)blankMAttStringWithCharSize:(CGSize)cSize baselineOffset:(CGPoint)blOffset
{
    
    blankW = cSize.width;
    blankH = cSize.height;
    Baseline_OffsetY = blOffset.y;
    
    CTRunDelegateCallbacks callbacks;
    memset(&callbacks, 0, sizeof(CTRunDelegateCallbacks));
    callbacks.version = kCTRunDelegateVersion1;
    callbacks.getAscent = ascentCallback;
    callbacks.getDescent = descentCallback;
    callbacks.getWidth = widthCallback;
    
    // 创建CTRun回调
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callbacks, NULL);
    
    // 使用 0xFFFC 作为空白的占位符
    unichar objectReplacementChar = 0xFFFC;
    NSString *string = [NSString stringWithCharacters:&objectReplacementChar length:1];
    
    NSMutableAttributedString *blankMAttString = [[NSMutableAttributedString alloc] initWithString:string];
    [blankMAttString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
    
    CFRelease(runDelegate);
    return blankMAttString;

}

static CGFloat ascentCallback(void *ref) {
    return blankW + Baseline_OffsetY;
}

static CGFloat descentCallback(void *ref) {
    return - Baseline_OffsetY;
}

static CGFloat widthCallback(void *ref) {
    return blankW;
}


@end




@implementation NSMutableAttributedString (Config_)

// 设置颜色
- (void)setTextColor:(NSColor *)color {
    [self setTextColor:color range:NSMakeRange(0, [self length])];
}

- (void)setTextColor:(NSColor *)color range:(NSRange)range {
    if (color.CGColor) {
        [self removeAttribute:(NSString *)kCTForegroundColorAttributeName range:range];
        [self addAttribute:(NSString *)kCTForegroundColorAttributeName
                     value:(id)color.CGColor
                     range:range];
    }
}

// 设置字体
- (void)setFont:(NSFont *)font {
    [self setFont:font range:NSMakeRange(0, self.length)];
}

- (void)setFont:(NSFont *)font range:(NSRange)range {
    if (font) {
        [self removeAttribute:(NSString*)kCTFontAttributeName range:range];
        CTFontRef fontRef = CTFontCreateWithName((CFStringRef)font.fontName, font.pointSize, nil);
        if (fontRef) {
            [self addAttribute:(NSString *)kCTFontAttributeName value:(__bridge id)fontRef range:range];
            CFRelease(fontRef);
        }
    }
}

- (void)setLineSpacing:(CGFloat)lineSpacing {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];//调整行间距
    [self addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self length])];
}

@end




@implementation  NSMutableAttributedString (AttachMent_)

+ (instancetype)mAttsWithAttachCell:(NSTextAttachmentCell *)attachmentCell
{
    NSTextAttachment *att = [[NSTextAttachment alloc] init];
    att.attachmentCell = attachmentCell;
    NSAttributedString *attString = [NSAttributedString attributedStringWithAttachment:att];
    NSMutableAttributedString *attStr = [NSMutableAttributedString mAttsWithAttString:attString];
    return attStr;
}


@end

@implementation NSMutableAttributedString (Calculate_)

- (CGSize)sizeForMaxLayoutWidth:(CGFloat)width
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self);
    // 获得要缓制的区域的高度
    CGSize restrictSize = CGSizeMake(width, CGFLOAT_MAX);
    CGSize coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(framesetter, CFRangeMake(0,0), nil, restrictSize, nil);
    return CGSizeMake(ceil(coreTextSize.width), coreTextSize.height);
}

- (CGSize)sizeForSingleLine
{
    CGFloat  ascent;
    CGFloat  descent;
    CGFloat  leading;
    CTLineRef lineRef = CTLineCreateWithAttributedString((CFAttributedStringRef)self);
    CGFloat width = CTLineGetTypographicBounds(lineRef, &ascent, &descent, &leading);
    width = ceil(width);
    CGFloat height = (ascent + leading + descent);
    return CGSizeMake(width, height);
}

@end
