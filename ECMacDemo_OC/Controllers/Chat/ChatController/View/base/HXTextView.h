//
//  HXTextView.h
//  SWAttributedLabel
//
//  Created by hanxiaoqing on 2016/10/21.
//  Copyright © 2016年 mxc235. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSScrollView+Enabled.h"

@interface HXTextView : NSTextView

/** 使用实例
 
 HXTextView *textView = [[HXTextView alloc] init];
 
 HXTextView 默认创建出来
 1.宽度为1的灰色边框 去除了系统的自带的边框
 2.没有Scroller
 3.textViewBgColor文字后面的背景view是白色
 
 textView.textContainerInset = NSMakeSize(0, 10.0); // 调整 文字的上下间距
 textView.drawsBackground = NO;   // 去除NSTextView 默认的所有背景
 textView.font = [NSFont systemFontOfSize:14];
 [textView insertText:mAttString replacementRange:NSMakeRange(0, 0)];
 self.textView.editable = NO; // 设置不可编辑,一定要在insertText之后！
 
 */



/** 边框宽度和颜色设置 */
@property (nonatomic,assign) CGFloat borderWidth;
@property (nonatomic,strong) NSColor *borderColor;

/** 文本框背景颜色 调整*/
@property (nonatomic,strong) NSColor *textViewBgColor;

/** 是否要Scroller */
@property (nonatomic,assign) BOOL hasScroller;

/** 是否能Edit */
@property (nonatomic,assign) BOOL canEdit;

@end
