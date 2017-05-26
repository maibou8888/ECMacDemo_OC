//
//  HXFacialSelectionPanel.m
//  SWAttributedLabel
//
//  Created by hanxiaoqing on 2016/11/2.
//  Copyright © 2016年 mxc235. All rights reserved.
//

#import "HXFacialSelectionPanel.h"
#import "HXEmotionBoard.h"
#import "HXEmotionToolBar.h"
#import "HXEmotionTool.h"

static const CGFloat toolBarHeight = 40;


@interface HXFacialSelectionPanel () <HXEmotionToolBarDelegate>

@property (nonatomic,strong) HXEmotionBoard *emotionBoard;
@property (nonatomic,strong) HXEmotionToolBar *toolBar;

@end

@implementation HXFacialSelectionPanel

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
    HXEmotionBoard *emotionBoard = [[HXEmotionBoard alloc] init];
    emotionBoard.emotions = [HXEmotionTool defaultEmotions];
    [self addSubview:emotionBoard];
    self.emotionBoard = emotionBoard;
    
    HXEmotionToolBar *toolBar = [[HXEmotionToolBar alloc] init];
    toolBar.delegate = self;
    [self addSubview:toolBar];
    self.toolBar = toolBar;
}

#pragma -mark HXEmotionToolBarDelegate

// 选中了哪种表情类型
- (void)emotionTypeSelect:(NSInteger)index {
    if (index == 0) {
        self.emotionBoard.emotions = [HXEmotionTool defaultEmotions];
    }
}

- (void)layout {
    [super layout];
    
    self.emotionBoard.frame = CGRectMake(0, toolBarHeight, NSWidth(self.frame), NSHeight(self.frame) - toolBarHeight);
    self.toolBar.frame = CGRectMake(0, 0, NSWidth(self.frame), toolBarHeight);
}


@end
