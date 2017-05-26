//
//  HXMineMessageCell.m
//  DingDing_Project
//
//  Created by hanxiaoqing on 2016/10/12.
//  Copyright © 2016年 HXQ. All rights reserved.
//

#import "HXMineMessageCell.h"
#import "HXTextGraphicsParser.h"
#import "HXButton.h"

#define BossColor  [NSColor colorWithRed:231/255.0 green:112/255.0 blue:193/255.0 alpha:1]

@interface HXMineMessageCell ()

@property (weak) IBOutlet NSImageView *iconImage;
@property (unsafe_unretained) IBOutlet HXTextView *msgTextView;
@property (weak) IBOutlet NSLayoutConstraint *textHeightCons;
@property (weak) IBOutlet NSLayoutConstraint *textWidthCons;
@end

@implementation HXMineMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.canTrackAction = YES;
    self.msgTextView.textContainerInset = NSMakeSize(5, 8.0);
    self.msgTextView.drawsBackground = NO;
    self.msgTextView.font = [NSFont systemFontOfSize:14.0f];
    self.msgTextView.borderColor = [NSColor clearColor];
    self.msgTextView.textViewBgColor = HXSColor(64, 175, 252);
    self.msgTextView.textColor = HXSColor(228, 244, 255);
    self.msgTextView.canEdit = NO;
}

- (void)setMessage:(ECMessage *)message {
    _message = message;
    ECTextMessageBody *body = (ECTextMessageBody *)message.messageBody;
    self.iconImage.image = [NSImage circleImageWithColor:BossColor size:self.iconImage.frame.size text:@"我"];
    self.msgTextView.string = body.text;
    self.msgTextView.editable = NO;
    
    HXTextGraphicsParser *parser = [HXTextGraphicsParser shareParser];
    [parser resultAttributedStringFromText:body.text];
    CGFloat width = [parser resultAttributeTextSizeForSingleLine].width;
    CGFloat height = [parser resultAttributeTextHeightForLayoutWidth:300];
    
    self.textWidthCons.constant = width < 300?(width + 20):320;
    self.textHeightCons.constant = height + 16;
}

@end
