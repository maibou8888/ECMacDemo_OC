//
//  ECGroupListCell.h
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/28.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ECGroupListCell : NSTableCellView

@property (weak) IBOutlet NSImageView *groupImage;
@property (weak) IBOutlet NSTextField *memberLabel;

@end
