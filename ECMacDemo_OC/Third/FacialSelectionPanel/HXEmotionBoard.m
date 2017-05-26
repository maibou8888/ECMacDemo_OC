//
//  HXEmotionBoard.m
//  SWAttributedLabel
//
//  Created by hanxiaoqing on 2016/11/2.
//  Copyright © 2016年 mxc235. All rights reserved.
//

#import "HXEmotionBoard.h"
#import "HXButton.h"

@interface HXDocomentView : NSView

@end

@interface HXEmotionBoard ()

@property (nonatomic,strong) HXDocomentView *docoment_View;

@end

@implementation HXEmotionBoard

- (HXDocomentView *)docoment_View {
    if (!_docoment_View) {
        _docoment_View = [[HXDocomentView alloc] init];
        _docoment_View.wantsLayer = YES;
//        _docoment_View.layer.backgroundColor = [NSColor redColor].CGColor;
    }
    return _docoment_View;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp {
    // 设置 scrollView 属性
    self.hasHorizontalScroller = NO;
    self.hasVerticalScroller = YES;
    self.documentView = self.docoment_View;
    
    // 每个表情按钮的宽高
    self.emotionWH = 35;
}


- (void)setEmotions:(NSArray *)emotions {
    _emotions = emotions;
    
    // 清除所有表情
    NSClipView *documentView = self.documentView;
    
    [documentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    //根据表情数量 计算content Size
    documentView.frame = [self contentRectWithEmotions:emotions.count];
    
    // 创建表情按钮
    CGFloat btnWH = self.emotionWH;
    for (NSInteger index = 0; index < emotions.count; index ++) {
        // 计算 需要的行数 列数
        NSInteger row = index / maxColumns; //行号
        NSInteger col = index % maxColumns; //列号
        
        // 设置 表情按钮
        HXButton *emotionBtn = [[HXButton alloc] init];
        emotionBtn.tag = index;
        [emotionBtn setTitle:emotions[index] forState:NSControlStateNormal];
        emotionBtn.backGroundColor = [NSColor clearColor];
        emotionBtn.target = self;
        emotionBtn.action = @selector(clickBtn:);
        CGFloat imageViewX = emotionMargin + col * (btnWH + emotionMargin);
        CGFloat imageViewY = emotionMargin + row * (btnWH + emotionMargin);
        emotionBtn.frame = CGRectMake(imageViewX, imageViewY, btnWH, btnWH);
        [self.documentView addSubview:emotionBtn];
    }
    
}

- (void)clickBtn:(HXButton *)btn {
    NSString *emotionStr = self.emotions[btn.tag];
    [Notification_center postNotificationName:EmotionSelectNotification object:emotionStr];
}

- (CGRect)contentRectWithEmotions:(NSInteger)emCount {
    CGFloat btnWH = self.emotionWH;
    NSInteger totalRow = (emCount + maxColumns - 1) / maxColumns;
    CGFloat documentW = emotionMargin + maxColumns * (btnWH + emotionMargin);
    CGFloat documentH = emotionMargin + totalRow * (btnWH + emotionMargin);
    return CGRectMake(0, 0, documentW, documentH);
}

- (void)layout {
    [super layout];
}

@end

@implementation HXDocomentView

- (BOOL)isFlipped {
    return YES;
}

@end
