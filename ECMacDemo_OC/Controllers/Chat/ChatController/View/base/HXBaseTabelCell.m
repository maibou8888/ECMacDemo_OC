//
//  HXBaseTabelCell.m
//  DingDing_Project
//
//  Created by hanxiaoqing on 2016/10/9.
//  Copyright © 2016年 HXQ. All rights reserved.
//

#import "HXBaseTabelCell.h"

@interface HXBaseTabelCell ()

@property (nonatomic,strong) NSTrackingArea *trackingArea;

@end

@implementation HXBaseTabelCell

- (NSTrackingArea *)trackingArea {
    if (!_trackingArea) {
        CGFloat TrackX =  70;
        CGFloat TrackY = NSMinY(self.frame);
        CGFloat TrackW = NSWidth(self.frame) - 70;
        CGFloat TrackH = NSHeight(self.frame);
        _trackingArea = [[NSTrackingArea alloc] initWithRect:CGRectMake(TrackX, TrackY, TrackW, TrackH)
                                                     options:NSTrackingActiveAlways | NSTrackingMouseEnteredAndExited
                                                       owner:self
                                                    userInfo:nil];
    }
    return _trackingArea;
}


- (NSTableRowView *)rowView {
    return (NSTableRowView *)self.superview;
}

- (void)viewDidMoveToWindow {
    if (self.selectionHighlighted) return;
    self.rowView.selectionHighlightStyle = NSTableViewSelectionHighlightStyleNone;
    if (self.canTrackAction) {
        [self addTrackingArea:self.trackingArea];
    }
}

@end
