//
//  HXEmotionBoard.h
//  SWAttributedLabel
//
//  Created by hanxiaoqing on 2016/11/2.
//  Copyright © 2016年 mxc235. All rights reserved.
//

#import <Cocoa/Cocoa.h>

static const NSInteger maxColumns = 8;

static const CGFloat emotionMargin = 15;


@interface HXEmotionBoard : NSScrollView

/** 显示的所有表情（里面都是HXEmotion模型） */
@property (nonatomic, strong) NSArray *emotions;
// 表情宽高
@property (nonatomic, assign) CGFloat emotionWH;

@end
