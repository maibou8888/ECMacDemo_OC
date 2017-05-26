//
//  MineVoiceCell.h
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/12.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HXBaseTabelCell.h"

@interface MineVoiceCell : HXBaseTabelCell

@property (weak) IBOutlet NSImageView *iconImageView;
@property (weak) IBOutlet NSImageView *voiceImageView;

@property (weak) IBOutlet NSView *backgroundView;
@property (weak) IBOutlet NSTextField *timeLabel;

@property (weak) IBOutlet NSLayoutConstraint *bgViewWidthCons;

-(void)loadImgWIthMessage:(ECMessage *)msg;

@end
