//
//  ECRightSplitView.h
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/24.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ECRightSplitView : NSSplitView


@property (weak) IBOutlet NSView * _Nullable rightLeftV;
@property (weak)IBOutlet NSView * _Nullable rightRigV;

@property (nonatomic, assign) BOOL isHiddenR;
@end
