//
//  HXButton.h
//  DingDing_Project
//
//  Created by hanxiaoqing on 16/8/29.
//  Copyright © 2016年NSQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
/**
 * 自定义button 参考资料代码
 http://blog.csdn.net/leonpengweicn/article/details/7750445
 https://github.com/Concpt13/MXButton
 */

typedef NS_OPTIONS(NSInteger,NSControlState) {
   NSControlStateNormal       = 0,
   NSControlStateHighlighted  = 1 << 0,                  // used whenNSControl isHighlighted is set
   NSControlStateDisabled     = 1 << 1,
   NSControlStateSelected     = 1 << 2,                  // flag usable by app (see below)
   NSControlStateMouseIn      = 1 << 3, // Applicable only when the screen supports focus
};


@interface HXButton : NSControl

@property(nonatomic)          NSEdgeInsets contentEdgeInsets; // default is UIEdgeInsetsZero. On tvOS 10 or later, default is nonzero except for custom buttons.
@property(nonatomic)          NSEdgeInsets titleEdgeInsets;                // default is UIEdgeInsetsZero
@property(nonatomic)          NSEdgeInsets imageEdgeInsets;                // default is UIEdgeInsetsZero

@property(nonatomic)          BOOL         adjustsImageWhenHighlighted;    // default is YES. if YES, image is drawn darker when highlighted(pressed)
@property(nonatomic)          BOOL         adjustsImageWhenDisabled;       // default is YES. if YES, image is drawn lighter when disabled

@property(nonatomic,assign) BOOL selected;

@property(nonatomic,strong,nonnull) NSFont *titleFont;


@property (nonatomic,assign) BOOL trackingEabled;                  // 是否允许 鼠标tracking trackingEabled = YES 的时候 设置ButtonStateMouseIn 状态下的样式才生效

- (void)setTitle:(nullable NSString *)title forState:(NSControlState)state;     // default is nil. title is assumed to be single line
- (void)setTitleColor:(nullable NSColor *)color forState:(NSControlState)state; // default if nil. use opaque white


- (void)setImage:(nullable NSImage *)image forState:(NSControlState)state;                      // default is nil. should be same size if different for different states

- (void)setBackgroundColor:(nullable NSColor *)color forState:(NSControlState)state;

@property(nonatomic,strong,nonnull) NSColor *backGroundColor;

@property(nonatomic,strong,readonly) NSString *titleString;

@end



