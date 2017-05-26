//
//  ContactCell2.h
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/25.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HXBaseTabelCell.h"

@interface ContactCell2 : HXBaseTabelCell

@property (nonatomic , retain) IBOutlet NSImageView *groupImage;
@property (nonatomic , retain) IBOutlet NSTextField *nameLabel;
@property (nonatomic , retain) IBOutlet NSTextField *phoneLabel;
@property (nonatomic , retain) IBOutlet NSButton    *selectBox;

@end
