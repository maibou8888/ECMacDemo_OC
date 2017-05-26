//
//  HXMsgDatailCell.m
//  DingDing_Project
//
//  Created by hanxiaoqing on 2016/10/9.
//  Copyright © 2016年 HXQ. All rights reserved.
//

#import "HXMsgDatailCell.h"
#import "NSImage+StackBlur.h"
#import "HXTextGraphicsParser.h"
#import "HXButton.h"

#define StaffColor [NSColor colorWithRed:236/255.0 green:121/255.0 blue:95/255.0  alpha:1]

@interface HXMsgDatailCell () <NSTextViewDelegate>

@property (weak) IBOutlet NSImageView *iconImageView;
@property (weak) IBOutlet NSTextField *nameLabel;
@property (unsafe_unretained) IBOutlet HXTextView *attTextView;
@property (weak) IBOutlet NSLayoutConstraint *textHeightCons;
@property (weak) IBOutlet NSLayoutConstraint *textWidthCons;

@end

@implementation HXMsgDatailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.canTrackAction = YES;
    self.attTextView.textContainerInset = NSMakeSize(5.0, 8.0);
    self.attTextView.font = [NSFont systemFontOfSize:14.0f];
    self.attTextView.drawsBackground = NO;
    self.attTextView.borderColor = HXColor(225, 224, 228);
    self.attTextView.textViewBgColor = HXSColor(64, 175, 252);
    self.attTextView.textColor = HXSColor(228, 244, 255);
    self.attTextView.delegate = self;
}

- (void)setMessage:(ECMessage *)message {
    _message = message;
    ECTextMessageBody *body = (ECTextMessageBody *)message.messageBody;
    self.iconImageView.image = [NSImage circleImageWithColor:StaffColor size:self.iconImageView.frame.size text:message.from];
    self.nameLabel.stringValue = message.from;
    self.attTextView.string = body.text;
    self.attTextView.editable = NO;
    
    HXTextGraphicsParser *parser = [HXTextGraphicsParser shareParser];
    [parser resultAttributedStringFromText:body.text];
    CGFloat width = [parser resultAttributeTextSizeForSingleLine].width;
    CGFloat height = [parser resultAttributeTextHeightForLayoutWidth:300];
    self.textWidthCons.constant = width < 300?(width + 20):320;
    self.textHeightCons.constant = height + 16;
}
@end
