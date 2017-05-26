//
//  ECMainController.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/19.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECMainController.h"

#define SessionMinW 180.0f
#define SessionW (84.0f+140.0f)

#define ChatGroupMinW 480.0f
#define ChatGroupMaxW 600.0f

#define ContactLeftMinW 200
#define ContactLeftMaxW 300

@implementation ECMainController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, mainW, mainH);
    [self.mainSplitView setPosition:SessionMinW ofDividerAtIndex:0];
    [self.rightSplitView setPosition:200 ofDividerAtIndex:0];
    [self.contactSplit setPosition:ContactLeftMinW ofDividerAtIndex:0];
}

#pragma mark - NSSplitViewDelegate

- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex {
    if (splitView == self.rightSplitView) {
        return ChatGroupMinW;
        
    }else if (splitView == self.contactSplit) {
        return ContactLeftMinW;
    }
    return SessionMinW;
}

- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex {
    if (splitView == self.rightSplitView) {
        return ChatGroupMaxW;
        
    }else if (splitView == self.contactSplit) {
        return ContactLeftMaxW;
    }
    return SessionW;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldAdjustSizeOfSubview:(NSView *)view {
    if (view == _leftView && splitView == self.mainSplitView){
        if (view.frame.size.width <= SessionMinW) {
            return NO;
        }
    } else if (view == self.rightSplitView.rightLeftV && splitView == self.rightSplitView) {
        if (view.frame.size.width <= ChatGroupMinW) {
            return NO;
        }
    } else if (view == _contactLeftView && splitView == _contactSplit) {
        if (view.frame.size.width <= ContactLeftMinW || view.frame.size.width >= ContactLeftMaxW) {
            return NO;
        }
    }
    return YES;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex {
    if (splitView == self.rightSplitView && self.rightSplitView.isHiddenR) {
        return YES;
    }
    return NO;
}

-(NSRect)splitView:(NSSplitView *)splitView effectiveRect:(NSRect)proposedEffectiveRect forDrawnRect:(NSRect)drawnRect ofDividerAtIndex:(NSInteger)dividerIndex {
    
    if (self.rightSplitView.isHiddenR)
        return NSZeroRect;
    return proposedEffectiveRect;
}

@end
