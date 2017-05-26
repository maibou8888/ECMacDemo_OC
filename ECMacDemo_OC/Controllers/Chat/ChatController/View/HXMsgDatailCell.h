//
//  HXMsgDatailCell.h
//  DingDing_Project
//
//  Created by hanxiaoqing on 2016/10/9.
//  Copyright © 2016年 HXQ. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HXBaseTabelCell.h"
#import "HXTextView.h"

#define  messageTextFont 14.0

@interface HXMsgDatailCell : HXBaseTabelCell

@property (nonatomic,strong) ECMessage *message;


@end
