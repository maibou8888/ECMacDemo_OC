//
//  ECImageViewController.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/17.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECImageViewController.h"
#import "NSImageView+WebCache.h"

@interface ECImageViewController ()

@property (weak) IBOutlet NSImageView *imageView;

@end

@implementation ECImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.localURL.length) {
        self.imageView.image = [[NSImage alloc] initWithContentsOfFile:self.localURL];

    }else if (self.remoteURL.length) {
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:self.remoteURL]];
    }
}

@end
