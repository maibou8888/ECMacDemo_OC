//
//  OtherImageCell.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/12.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "OtherImageCell.h"
#import "NSImage+StackBlur.h"
#import "NSImageView+WebCache.h"

#define StaffColor [NSColor colorWithRed:236/255.0 green:121/255.0 blue:95/255.0  alpha:1]

@implementation OtherImageCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

- (void)loadImgWIthMessage:(ECMessage *)msg {
    self.nameLabel.stringValue = msg.from;
    self.iconImageView.image = [NSImage circleImageWithColor:StaffColor size:self.iconImageView.frame.size text:msg.from];
    
    ECImageMessageBody *mediaBody = (ECImageMessageBody*)msg.messageBody;
    if (mediaBody.localPath.length>0 && [[NSFileManager defaultManager] fileExistsAtPath:mediaBody.localPath] && (mediaBody.mediaDownloadStatus==ECMediaDownloadSuccessed || msg.messageState != ECMessageState_Receive)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                self.localPath = mediaBody.localPath;
                NSImage *image = [[NSImage alloc] initWithContentsOfFile:mediaBody.localPath];
                if (image==nil) {
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    [ECCommonTools resizeWithImg:image w:image.size.width h:image.size.height];
                    self.contImageView.image = image;
                });
            }
        });
        
    } else if (msg.messageState == ECMessageState_Receive && mediaBody.thumbnailRemotePath.length>0) {
        self.remotePath = mediaBody.thumbnailRemotePath;
        [self.contImageView sd_setImageWithURL:[NSURL URLWithString:mediaBody.thumbnailRemotePath]];
        
    } else  {
        self.contImageView.image = [NSImage imageNamed:@"chat_placeholder_image"];
    }
}

@end
