//
//  ECChatMainSplitController.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/27.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECChatMainSplitController.h"
#import "ECChatController.h"
#import "ECChatToolController.h"

#define chatMinW 280.0f
#define chatMaxW 220.0f
@interface ECChatMainSplitController ()

@end

@implementation ECChatMainSplitController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareUI];
}

- (void)prepareUI {
    NSSplitViewItem *topSplitItem = [NSSplitViewItem splitViewItemWithViewController:[[ECChatController alloc] init]];
    [self addSplitViewItem:topSplitItem];
    [self addSplitViewItem:[NSSplitViewItem splitViewItemWithViewController:[[ECChatToolController alloc] init]]];
    
    self.splitView.dividerStyle = NSSplitViewDividerStyleThin;
    self.splitView.vertical = NO;
    [self.splitView setPosition:chatMinW ofDividerAtIndex:0];
}

@end
