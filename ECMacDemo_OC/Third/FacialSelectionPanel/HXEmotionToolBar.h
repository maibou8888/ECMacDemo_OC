//
//  HXEmotionToolBar.h
//  SWAttributedLabel
//
//  Created by hanxiaoqing on 2016/11/2.
//  Copyright © 2016年 mxc235. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol HXEmotionToolBarDelegate <NSObject>

@optional
- (void)emotionTypeSelect:(NSInteger)index;

@end

// 工具栏 按钮的宽高
#define toolBarBtnSize CGSizeMake(40, 40)

@interface HXEmotionToolBar : NSView

/** 所有表情类型  */
@property (nonatomic, strong) NSArray *emotionTypes;

@property (nonatomic, weak) id<HXEmotionToolBarDelegate> delegate;

@end
