//
//  HXTextGraphicsParser.h
//  DingDing_Project
//
//  Created by hanxiaoqing on 2017/1/16.
//  Copyright © 2017年 HXQ. All rights reserved.
//

#import <AppKit/AppKit.h>

#import "RegexKitLite.h"
#import "HXEmotionTool.h"
#import "HXSpecial.h"

#import "NSMutableAttributedString+HXPromote.h"


@interface HXTextGraphicsParser : NSObject

+ (instancetype)shareParser;


/** 解析特殊字符串的正则表达式*/
@property (copy, nonatomic) NSString *pattarnRegex;

/** 图片文字附件的一些属性 Size（大小） BaselineOffset（基准线的偏移量） */
@property (nonatomic,assign) CGSize  attachGraphicsSize;
@property (nonatomic,assign) CGPoint attachGraphicsCharBaselineOffset;

/** 生成的attributedString的一些属性  */
@property (assign, nonatomic) CGFloat attributedStringLineSpace;

/**
 从带有特殊字符（表情，高亮@ #话题#等）源字符串解析出 属性字符串
 @param text 输入字符串
 @return 输出AttributedString
 */
- (NSMutableAttributedString *)resultAttributedStringFromText:(NSString *)text;

/**
 计算最终生成的AttributedString 在指定宽度下的总高度

 @param width 限定宽度
 @return 高度
 */
- (CGFloat)resultAttributeTextHeightForLayoutWidth:(CGFloat)width;



/**
 <#Description#>

 @return <#return value description#>
 */
- (CGSize)resultAttributeTextSizeForSingleLine;
@end
