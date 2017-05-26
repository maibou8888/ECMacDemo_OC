//
//  HXEmotionToolBar.m
//  SWAttributedLabel
//
//  Created by hanxiaoqing on 2016/11/2.
//  Copyright © 2016年 mxc235. All rights reserved.
//

#import "HXEmotionToolBar.h"
#import "HXButton.h"

@interface HXEmotionToolBar ()

@property (nonatomic,assign) HXButton *lastSelectBtn;

@end

@implementation HXEmotionToolBar

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
    
    self.wantsLayer = YES;
    self.layer.backgroundColor = [NSColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:1.0].CGColor;
    self.emotionTypes = @[[NSImage imageNamed:@"icon_face.png"]];
}

- (void)setEmotionTypes:(NSArray *)emotionTypes {
    _emotionTypes = emotionTypes;
    
    CGFloat margin = 15;
    for (NSInteger index = 0; index < emotionTypes.count; index++) {
        // 设置 表情类型按钮
        HXButton *typeBtn = [[HXButton alloc] init];
        typeBtn.tag = index;
        typeBtn.imageEdgeInsets = NSEdgeInsetsMake(10, 10, 10, 10);
        [typeBtn setImage:emotionTypes[index] forState:NSControlStateNormal];
        [typeBtn setBackgroundColor:[NSColor clearColor] forState:NSControlStateNormal];
        [typeBtn setBackgroundColor:[NSColor whiteColor] forState:NSControlStateSelected];
        typeBtn.target = self;
        typeBtn.action = @selector(clickBtn:);
        CGFloat btnX = margin + (toolBarBtnSize.width + margin) * index;
        typeBtn.frame = CGRectMake(btnX, 0, toolBarBtnSize.width, toolBarBtnSize.height);
        [self addSubview:typeBtn];
        if (index == 0)  [self clickBtn:typeBtn];
    }
    
}

- (void)clickBtn:(HXButton *)typeBtn {
    self.lastSelectBtn.selected = NO; // 上一个按钮取消选中
    typeBtn.selected = YES; // 当前按钮选中
    self.lastSelectBtn = typeBtn; // 赋值最新按钮
    if ([self.delegate respondsToSelector:@selector(emotionTypeSelect:)]) {
        [self.delegate emotionTypeSelect:typeBtn.tag];
    }
}


- (void)layout {
    [super layout];
    
}

@end
