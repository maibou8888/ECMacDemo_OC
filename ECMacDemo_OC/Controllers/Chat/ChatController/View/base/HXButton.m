//
//  HXButton.m
//  DingDing_Project
//
//  Created by hanxiaoqing on 16/8/29.
//  Copyright © 2016年 HXQ. All rights reserved.
//

#import "HXButton.h"

@interface HXButton ()

@property (nonatomic,strong) NSMutableDictionary *stateImageDic;

@property (nonatomic,strong) NSMutableDictionary *stateTitleColorDic;

@property (nonatomic,strong) NSMutableDictionary *stateBgColorDic;

@property (nonatomic,strong) NSTrackingArea *trackingArea;


//@property (nonatomic,copy) NSString *displayTitle;


@property (nonatomic,copy)   NSMutableAttributedString *currtentDisplayString;

@property (nonatomic,strong) NSImage *currtentDisplayImage;
@property (nonatomic,strong) NSImageView *imageView;

@property (nonatomic,assign) BOOL mouseDown;

@end



@implementation HXButton

- (NSMutableDictionary *)stateImageDic {
    if (!_stateImageDic) {
        _stateImageDic = [NSMutableDictionary dictionary];
    }
    return _stateImageDic;
}

- (NSMutableDictionary *)stateBgColorDic {
    if (!_stateBgColorDic) {
        _stateBgColorDic = [NSMutableDictionary dictionary];
    }
    return _stateBgColorDic;
}

- (NSMutableDictionary *)stateTitleColorDic {
    if (!_stateTitleColorDic) {
        _stateTitleColorDic = [NSMutableDictionary dictionary];
    }
    return _stateTitleColorDic;
}

- (instancetype)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setUp];
}

- (void)setUp
{
    self.wantsLayer = YES;
 
    self.titleFont = [NSFont systemFontOfSize:13];
    
    [self setTitleColor:[NSColor blackColor] forState:NSControlStateNormal];
    
    NSImageView *imageView = [[NSImageView alloc] init];
    [self addSubview:imageView];
    self.imageView = imageView;
    
}


- (void)drawRect:(NSRect)dirtyRect
{
    if (self.highlighted) { } // do highlighted things
    
    self.imageView.frame = [self imageRectForBounds:dirtyRect];
    
    NSAttributedString *disPlayString = self.currtentDisplayString;
    CGFloat stringH =  NSHeight(dirtyRect);
    CGFloat stringY = (stringH - disPlayString.size.height) * 0.5;
    CGFloat stringW =  NSWidth(dirtyRect);
    CGRect  titleRect = CGRectMake(0, -stringY, stringW, stringH);
    
    [disPlayString drawWithRect:[self titleRectForBounds:titleRect] options:NSStringDrawingUsesLineFragmentOrigin];
}

- (NSRect)titleRectForBounds:(NSRect)theRect
{
    NSEdgeInsets padding = self.titleEdgeInsets;
    theRect.origin.x += padding.left;
    theRect.origin.y += padding.top;
    theRect.size.width -= (padding.left + padding.right);
    theRect.size.height -= (padding.top + padding.bottom);
    return theRect;
}


- (NSRect)imageRectForBounds:(NSRect)theRect
{
    NSEdgeInsets padding = self.imageEdgeInsets;
    theRect.origin.x += padding.left;
    theRect.origin.y += padding.top;
    theRect.size.width -= (padding.left + padding.right);
    theRect.size.height -= (padding.top + padding.bottom);
    return theRect;
}



- (void)bulidDisplayStringWith:(NSString *)title
{
    NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
//    pStyle.alignment = NSTextAlignmentCenter;
    pStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    NSColor *normalStateTitleColor = self.stateTitleColorDic[@(NSControlStateNormal)];
    if (!normalStateTitleColor) {
        normalStateTitleColor = [NSColor blackColor];
    }

    NSDictionary *atts = [NSDictionary dictionaryWithObjectsAndKeys:
                          normalStateTitleColor,NSForegroundColorAttributeName,
                          self.titleFont,NSFontAttributeName,
                          pStyle,NSParagraphStyleAttributeName
                          , nil];
    
    NSMutableAttributedString *displayString = [[NSMutableAttributedString alloc]
                                                initWithString:title
                                                attributes:atts];
    self.currtentDisplayString = displayString;
}


- (NSTrackingArea *)trackingArea {
    if (!_trackingArea) {
        _trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                     options:NSTrackingInVisibleRect | NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited
                                                       owner:self
                                                    userInfo:nil];
    }
    return _trackingArea;
}

- (void)setBackGroundColor:(NSColor *)backGroundColor {
    _backGroundColor = backGroundColor;
    self.layer.backgroundColor = backGroundColor.CGColor;
}

- (void)setTrackingEabled:(BOOL)trackingEabled {
    _trackingEabled = trackingEabled;
    if (trackingEabled) {
        [self addTrackingArea:self.trackingArea];
    } else {
        [self removeTrackingArea:self.trackingArea];
    }
}

- (void)setBackgroundColor:(nullable NSColor *)color forState:(NSControlState)state
{
    [self.stateBgColorDic setObject:color forKey:@(state)];
    if (state == NSControlStateNormal) {
        self.layer.backgroundColor = color.CGColor;
    }
}

- (void)setTitle:(nullable NSString *)title forState:(NSControlState)state
{
    [self bulidDisplayStringWith:title];
    [self setNeedsDisplay:YES];
}

- (void)setTitleColor:(nullable NSColor *)color forState:(NSControlState)state
{
    [self.stateTitleColorDic setObject:color forKey:@(state)];
}

- (void)setImage:(nullable NSImage *)image forState:(NSControlState)state
{
    [self.stateImageDic setObject:image forKey:@(state)];
    if (state == NSControlStateNormal) {
        self.imageView.image = image;
    }
}



- (void)setSelected:(BOOL)selected
{
    _selected = selected;
    
    NSImage *normalStateImage      = self.stateImageDic[@(NSControlStateNormal)];
    NSColor *normalStateTitleColor = self.stateTitleColorDic[@(NSControlStateNormal)];
    NSColor *normalbackGroundColor = self.stateBgColorDic[@(NSControlStateNormal)];
    
    NSImage *image;
    NSColor *titleColor;
    NSColor *backGroundColor;
    
    if (selected) {
        image      = self.stateImageDic[@(NSControlStateSelected)];
        titleColor = self.stateTitleColorDic[@(NSControlStateSelected)];
        backGroundColor = self.stateBgColorDic[@(NSControlStateSelected)];
        if (!image) {
            image = normalStateImage;
        }
        if (!titleColor) {
            titleColor = normalStateTitleColor;
        }
        if (!backGroundColor) {
            backGroundColor = normalbackGroundColor;
        }
    }
    else {
        image      = normalStateImage;
        titleColor = normalStateTitleColor;
        backGroundColor = normalbackGroundColor;
    }
    
    self.backGroundColor = backGroundColor;
    [self updateTitleColor:titleColor];
    self.imageView.image = image;
    [self setNeedsDisplay];
}

- (void)updateTitleColor:(NSColor *)color {
    NSMutableAttributedString *mattStr = [self.currtentDisplayString mutableCopy];
    [mattStr addAttribute:NSForegroundColorAttributeName
                    value:color
                    range:NSMakeRange(0, mattStr.length)];
    
    self.currtentDisplayString = mattStr;
}


- (void)mouseEntered:(NSEvent *)event
{
    self.imageView.image = self.stateImageDic[@(NSControlStateMouseIn)];
    NSColor *titleColor = self.stateTitleColorDic[@(NSControlStateMouseIn)];
    if (titleColor) {
        [self updateTitleColor:titleColor];
    }
    [self setNeedsDisplay];
}

- (void)mouseExited:(NSEvent *)event
{
    self.imageView.image = self.stateImageDic[@(NSControlStateNormal)];
    NSColor *titleColor = self.stateTitleColorDic[@(NSControlStateNormal)];
    if (titleColor) {
        [self updateTitleColor:titleColor];
    }
    [self setNeedsDisplay];
}


- (void)mouseDown:(NSEvent *)theEvent
{
    _mouseDown = YES;
    self.needsDisplay = YES;
}

- (void)mouseUp:(NSEvent *)theEvent
{
    if (_mouseDown) {
        _mouseDown = NO;
        self.needsDisplay = YES;
        if (self.target && self.action) {
            [self.target performSelector:self.action withObject:self afterDelay:0.0];
        }
    }
}

- (NSString *)titleString {
    return self.currtentDisplayString.string;
}

@end
