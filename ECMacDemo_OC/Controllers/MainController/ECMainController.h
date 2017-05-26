//
//  ECMainController.h
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/19.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ECMainSplitView.h"
#import "ECRightSplitView.h"

#define mainW 1000.0f
#define mainH 700.0f

@interface ECMainController : NSViewController

@property (weak) IBOutlet NSSplitView *contactSplit;
@property (weak) IBOutlet NSView *contactLeftView;
@property (weak) IBOutlet NSView *contactRightView;

@property (weak) IBOutlet NSView *NavView;

@property (weak) IBOutlet ECMainSplitView *mainSplitView;
@property (weak) IBOutlet NSView *leftView;
@property (weak) IBOutlet NSView *rightView;

@property (weak) IBOutlet ECRightSplitView *rightSplitView;
@end
