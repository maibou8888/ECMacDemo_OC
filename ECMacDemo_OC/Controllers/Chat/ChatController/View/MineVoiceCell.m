//
//  MineVoiceCell.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/12.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "MineVoiceCell.h"
#import "NSImage+StackBlur.h"

#define BossColor  [NSColor colorWithRed:231/255.0 green:112/255.0 blue:193/255.0 alpha:1]

@implementation MineVoiceCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    self.backgroundView.wantsLayer = YES;
    self.backgroundView.layer.borderColor = HXColor(225, 224, 228).CGColor;
    self.backgroundView.layer.cornerRadius = 4.0f;
    self.backgroundView.layer.masksToBounds = YES;
    self.backgroundView.layer.backgroundColor = HXSColor(64, 175, 252).CGColor;
}

- (void)loadImgWIthMessage:(ECMessage *)msg {
    self.iconImageView.image = [NSImage circleImageWithColor:BossColor size:self.iconImageView.frame.size text:@"我"];
    
    ECVoiceMessageBody *mediaBody = (ECVoiceMessageBody*)msg.messageBody;
    if ([[NSFileManager defaultManager] fileExistsAtPath:mediaBody.localPath] && (mediaBody.mediaDownloadStatus==ECMediaDownloadSuccessed || msg.messageState != ECMessageState_Receive))
    {
        unsigned long long fileSize = [[[NSFileManager defaultManager] attributesOfItemAtPath:mediaBody.localPath error:nil] fileSize];
        mediaBody.duration = (int)(fileSize/650);
        if (mediaBody.duration == 0) {
            mediaBody.duration = 1;
        }
        self.timeLabel.stringValue = [NSString stringWithFormat:@"%d″",(int)mediaBody.duration];
        self.timeLabel.hidden = NO;
    } else {
        mediaBody.duration = 0;
        self.timeLabel.hidden = YES;
    }
    
    CGFloat width = [ECCommonTools getWidthWithTime:mediaBody.duration];
    self.bgViewWidthCons.constant = width;
}

@end
