//
//  ECNavView.h
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/19.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^ClickedMessgeBtn)(id sender);
typedef void(^ClickedContactsBtn)(id sender);

@interface ECNavView : NSView

@property (nonatomic, strong) ClickedMessgeBtn block1;
@property (nonatomic, strong) ClickedContactsBtn block2;

@end
