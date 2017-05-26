//
//  HXTextGraphicsParser.m
//  DingDing_Project
//
//  Created by hanxiaoqing on 2017/1/16.
//  Copyright © 2017年 HXQ. All rights reserved.
//

#import "HXTextGraphicsParser.h"

@interface HXTextPart : NSObject
/** 这段文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 是否为特殊文字 */
@property (nonatomic, assign, getter = isSpecical) BOOL special;
/** 是否为表情 */
@property (nonatomic, assign, getter = isEmotion) BOOL emotion;

@end



@interface HXAttachCell : NSTextAttachmentCell
/** 字符附件image */
@property (nonatomic,strong) NSImage *attachImage;
/** 字符附件size */
@property (nonatomic,assign) CGSize attachSize;
/** 字符站位baselineOffset */
@property (nonatomic,assign) CGPoint baselineOffset;

@end



@interface HXTextGraphicsParser () 

@property (nonatomic,strong) NSMutableAttributedString *calculateString;

@end


@implementation HXTextGraphicsParser

+ (instancetype)shareParser {
    static HXTextGraphicsParser *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        // 表情的规则
        NSString *emotionPattern = @"\\[[0-9a-zA-Z\\u4e00-\\u9fa5]+\\]";
        // @的规则
        NSString *atPattern = @"@[0-9a-zA-Z\\u4e00-\\u9fa5-_]+";
        // #话题#的规则
        NSString *topicPattern = @"#[0-9a-zA-Z\\u4e00-\\u9fa5]+#";
        // url链接的规则
        NSString *urlPattern =@"http(s)?://([a-zA-Z|\\d]+\\.)+[a-zA-Z|\\d]+(/[a-zA-Z|\\d|\\-|\\+|_./?%&=]*)?";
        self.pattarnRegex = [NSString stringWithFormat:@"%@|%@|%@|%@", emotionPattern, atPattern, topicPattern, urlPattern];
        
        self.attachGraphicsSize = CGSizeMake(30, 30);
        self.attachGraphicsCharBaselineOffset = CGPointMake(0, -8);
        self.attributedStringLineSpace = 5.0;
        
    }
    return self;
}

- (NSArray *)patternPartsWithRegex:(NSString *)regex originString:(NSString *)Ostr {
    // 遍历所有的特殊字符串
    NSMutableArray *parts = [NSMutableArray array];
    [Ostr enumerateStringsMatchedByRegex:regex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        HXTextPart *part = [[HXTextPart alloc] init];
        part.text = *capturedStrings;
        part.emotion = [part.text hasPrefix:@"["] && [part.text hasSuffix:@"]"];
        part.special = YES;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 遍历所有的非特殊字符
    [Ostr enumerateStringsSeparatedByRegex:regex usingBlock:^(NSInteger captureCount, NSString *const __unsafe_unretained *capturedStrings, const NSRange *capturedRanges, volatile BOOL *const stop) {
        if ((*capturedRanges).length == 0) return;
        HXTextPart *part = [[HXTextPart alloc] init];
        part.text = *capturedStrings;
        part.range = *capturedRanges;
        [parts addObject:part];
    }];
    
    // 系统是按照从小 -> 大的顺序排列对象
    [parts sortUsingComparator:^NSComparisonResult(HXTextPart *part1, HXTextPart *part2) {
        if (part1.range.location > part2.range.location) {
            return NSOrderedDescending;
        }
        return NSOrderedAscending;
    }];
    
    return parts;
}

- (NSMutableAttributedString *)emotionAttsWithText:(NSString *)text
{
    return nil;
}

- (NSMutableAttributedString *)resultAttributedStringFromText:(NSString *)text
{
    // 按顺序拼接每一段文字
    NSMutableAttributedString *resultAttString = [NSMutableAttributedString new];
    [resultAttString setLineSpacing:self.attributedStringLineSpace];
    
    
    NSMutableAttributedString *calculateString = [resultAttString mutableCopy];
    
    for (HXTextPart *part in [self patternPartsWithRegex:self.pattarnRegex originString:text]) {
        // 等会需要拼接的子串
        NSMutableAttributedString *substr = nil;
        // 由于计算含有attachMent的属性文字宽高不准确 提供一个临时的用CTRunDelegate代表表情的属性文字用于计算单行宽度
        NSMutableAttributedString *subCalculateString = nil;
        
        if (part.isEmotion) { // 表情

            substr = [self emotionAttsWithText:part.text];
            subCalculateString = [NSMutableAttributedString blankMAttStringWithCharSize:self.attachGraphicsSize baselineOffset:self.attachGraphicsCharBaselineOffset];
            
        }
        else if (part.special) { // 非表情的特殊文字
            
            substr = [[NSMutableAttributedString alloc] initWithString:part.text];
            [substr addAttribute:NSLinkAttributeName
                           value:part.text
                           range:NSMakeRange(0, substr.length)];
            [substr setFont:[NSFont systemFontOfSize:14.0]];
            
            subCalculateString = substr;
            
        }
        else { // 非特殊文字
            substr = [[NSMutableAttributedString alloc] initWithString:part.text];
            [substr setFont:[NSFont systemFontOfSize:15.0] range:NSMakeRange(0, part.text.length)];
            subCalculateString = substr;
        }
        [resultAttString appendAttributedString:substr];
        [calculateString appendAttributedString:subCalculateString];
    }
    
    self.calculateString = calculateString;
    
    return resultAttString;
    
}


- (CGFloat)resultAttributeTextHeightForLayoutWidth:(CGFloat)width
{
    if (self.calculateString == nil) return 0;
    return [self.calculateString sizeForMaxLayoutWidth:width].height;
}

- (CGSize)resultAttributeTextSizeForSingleLine
{
    if (self.calculateString == nil) return CGSizeZero;
    return [self.calculateString sizeForSingleLine];
}


@end

@implementation HXTextPart

@end


@implementation HXAttachCell

- (void)drawWithFrame:(NSRect)cellFrame inView:(nullable NSView *)controlView {
    [self.attachImage drawInRect:cellFrame];
}

- (NSSize)cellSize {
    return self.attachSize;
}
- (NSPoint)cellBaselineOffset {
    return self.baselineOffset;
}

@end


