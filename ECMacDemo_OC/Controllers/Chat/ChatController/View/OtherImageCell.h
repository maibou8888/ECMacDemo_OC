//
//  OtherImageCell.h
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/12.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HXBaseTabelCell.h"

@interface OtherImageCell : HXBaseTabelCell

@property (nonatomic , copy) NSString *localPath;
@property (nonatomic , copy) NSString *remotePath;

@property (weak) IBOutlet NSTextField *nameLabel;
@property (weak) IBOutlet NSImageView *iconImageView;
@property (weak) IBOutlet NSImageView *contImageView;

- (void)loadImgWIthMessage:(ECMessage *)msg;

@end
