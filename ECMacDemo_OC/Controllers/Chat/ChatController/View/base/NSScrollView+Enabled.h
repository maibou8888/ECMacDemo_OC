//
//  NSScrollView+Enabled.h
//  DingDing_Project
//
//  Created by hanxiaoqing on 2016/10/24.
//  Copyright © 2016年 HXQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSScrollView (Enabled)

/** 是否能 滚动 */
@property (assign, nonatomic) BOOL disableScroller;

@end
