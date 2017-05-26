//
//  HXTextView.m
//  SWAttributedLabel
//
//  Created by hanxiaoqing on 2016/10/21.
//  Copyright © 2016年 mxc235. All rights reserved.
//

#import "HXTextView.h"

@interface HXTextView ()

@property (nonatomic,strong) NSView *backGroundView;

@end


@implementation HXTextView


- (NSView *)backGroundView {
    if (!_backGroundView) {
        _backGroundView = [[NSView alloc] init];
        _backGroundView.wantsLayer = YES;
        _backGroundView.layer.cornerRadius = 8;
        _backGroundView.layer.masksToBounds = YES;
        _backGroundView.layer.borderWidth = 1;
        _backGroundView.layer.borderColor = [NSColor grayColor].CGColor;
        _backGroundView.layer.backgroundColor = [NSColor whiteColor].CGColor;
    }
    return _backGroundView;
}


- (void)setBorderWidth:(CGFloat)borderWidth {
    self.backGroundView.layer.borderWidth = borderWidth;
    NSRect rect = self.bounds;
    NSRect newRect = NSMakeRect(rect.origin.x + borderWidth,
                                rect.origin.y + borderWidth,
                                rect.size.width - borderWidth,
                                rect.size.height - borderWidth);
    self.backGroundView.frame = newRect;
}

- (void)setBorderColor:(NSColor *)borderColor {
    // 一旦设置了borderColor，就去除textView的默认边框
    self.enclosingScrollView.borderType = NSNoBorder;
    self.backGroundView.layer.borderColor = borderColor.CGColor;
}

- (void)setTextViewBgColor:(NSColor *)textViewBgColor {
    self.backGroundView.layer.backgroundColor = textViewBgColor.CGColor;
}


- (void)setHasScroller:(BOOL)hasScroller {
    _hasScroller = hasScroller;
    self.enclosingScrollView.hasVerticalScroller = hasScroller;
    self.enclosingScrollView.hasHorizontalScroller = hasScroller;
}

- (instancetype)initWithFrame:(NSRect)frame {
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
    self.canEdit = YES;
    self.hasScroller = NO;
    self.enclosingScrollView.disableScroller = YES;
    self.enclosingScrollView.borderType = NSNoBorder;
    [self.superview addSubview:self.backGroundView positioned:NSWindowBelow relativeTo:self];
}


- (void)setDrawsBackground:(BOOL)drawsBackground {
    [super setDrawsBackground:drawsBackground];
    // 把包装 textView的上层NSClipView 的drawsBackground同步修改
    NSClipView *clipView = (NSClipView *) self.superview;
    clipView.drawsBackground = drawsBackground;
    
}

- (void)drawViewBackgroundInRect:(NSRect)rect {
    [super drawViewBackgroundInRect:rect];
    
//    NSRect newRect = NSMakeRect(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height);
//    NSBezierPath *textViewSurround = [NSBezierPath bezierPathWithRoundedRect:newRect xRadius:8 yRadius:8];
//    [textViewSurround setLineWidth:1.0];
//    [[NSColor grayColor] set];
//    [textViewSurround stroke];
}

- (void)layout {
    [super layout];
    NSRect rect = self.bounds;
    NSRect newRect = NSMakeRect(rect.origin.x + 0, rect.origin.y + 0, rect.size.width - 0, rect.size.height - 0);
    self.backGroundView.frame = newRect;
}

- (void)keyDown:(NSEvent *)event {
    [super keyDown:event];
}



@end
