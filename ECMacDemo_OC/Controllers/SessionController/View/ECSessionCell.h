//
//  ECSessionCell.h
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/20.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ECSessionCell : NSTableCellView

@property (weak) IBOutlet NSImageView *iconImgV;
@property (weak) IBOutlet NSButton *offBtn;

@property (weak) IBOutlet NSTextField *sessionF;
@property (weak) IBOutlet NSTextField *contentF;
@property (weak) IBOutlet NSButton *bageNum;

@end
