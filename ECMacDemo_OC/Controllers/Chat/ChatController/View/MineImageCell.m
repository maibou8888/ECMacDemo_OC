//
//  ECChatImageCell.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/5.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "MineImageCell.h"
#import "NSImage+StackBlur.h"
#import "NSImageView+WebCache.h"

#define BossColor  [NSColor colorWithRed:231/255.0 green:112/255.0 blue:193/255.0 alpha:1]

@implementation MineImageCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

-(void)loadImgWIthMessage:(ECMessage *)msg {
    ECImageMessageBody *mediaBody = (ECImageMessageBody*)msg.messageBody;
    self.iconImageView.image = [NSImage circleImageWithColor:BossColor size:self.iconImageView.frame.size text:@"我"];

    if (mediaBody.localPath.length>0 && [[NSFileManager defaultManager] fileExistsAtPath:mediaBody.localPath] && (mediaBody.mediaDownloadStatus==ECMediaDownloadSuccessed || msg.messageState != ECMessageState_Receive)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                self.localPath = mediaBody.localPath;
                NSImage *image = [[NSImage alloc] initWithContentsOfFile:mediaBody.localPath];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [ECCommonTools resizeWithImg:image w:image.size.width h:image.size.height];
                        self.contImageView.image = image;
                    });
                }
            }
        });
        
    } else if (msg.messageState == ECMessageState_Receive && mediaBody.thumbnailRemotePath.length>0) {
        self.remotePath = mediaBody.thumbnailRemotePath;
        [self.contImageView sd_setImageWithURL:[NSURL URLWithString:mediaBody.thumbnailRemotePath]];
    } else
        self.contImageView.image = [NSImage imageNamed:@"chat_placeholder_image"];
}

@end
