//
//  HXBaseTabelCell.h
//  DingDing_Project
//
//  Created by hanxiaoqing on 2016/10/9.
//  Copyright © 2016年 HXQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface HXBaseTabelCell : NSTableCellView

// 是否有cell选中高亮状态 默认是没有
@property (nonatomic,assign) BOOL selectionHighlighted;

@property (nonatomic,strong,readonly) NSTableRowView *rowView;

@property (nonatomic,assign) BOOL canTrackAction;

@end
