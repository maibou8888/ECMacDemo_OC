//
//  ECChatImageCell.h
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/5.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ECChatImageCell : NSTableCellView

@property (weak)IBOutlet NSImageView *chatImageView;
@property (weak)IBOutlet NSTextField *meField;

- (void)loadImgWIthMessage:(ECMessage *)msg;

@end
