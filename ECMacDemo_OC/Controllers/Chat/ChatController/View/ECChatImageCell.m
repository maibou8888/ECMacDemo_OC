//
//  ECChatImageCell.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/5.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECChatImageCell.h"
#import "NSImageView+WebCache.h"

@implementation ECChatImageCell

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    // Drawing code here.
}

-(void)loadImgWIthMessage:(ECMessage *)msg {
    ECImageMessageBody *mediaBody = (ECImageMessageBody*)msg.messageBody;
    if (mediaBody.localPath.length>0 && [[NSFileManager defaultManager] fileExistsAtPath:mediaBody.localPath] && (mediaBody.mediaDownloadStatus==ECMediaDownloadSuccessed || msg.messageState != ECMessageState_Receive)) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                NSImage *image = [[NSImage alloc] initWithContentsOfFile:mediaBody.localPath];
                if (image==nil) {
                    return;
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    self.chatImageView.image = image;
                    self.meField.stringValue = [NSString stringWithFormat:@"- (from %@)",msg.from];
                });
            }
        });
        
    } else if (msg.messageState == ECMessageState_Receive && mediaBody.thumbnailRemotePath.length>0) {
        [self.imageView setImageURL:[NSURL URLWithString:mediaBody.thumbnailRemotePath]];
        self.meField.stringValue = [NSString stringWithFormat:@"- (from %@)",msg.from];

     } else  {
        self.chatImageView.image = [NSImage imageNamed:@"chat_placeholder_image"];
         self.meField.stringValue = [NSString stringWithFormat:@"- (from %@)",msg.from];
    }

}

@end
