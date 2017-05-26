//
//  ECEmojiController.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/28.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECEmojiController.h"
#import "HXFacialSelectionPanel.h"


@interface ECEmojiController ()

@property (nonatomic,strong) HXFacialSelectionPanel *facialPanel;
@end

@implementation ECEmojiController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.facialPanel.wantsLayer = YES;
}

#pragma mark - lazy
- (HXFacialSelectionPanel *)facialPanel {
    if (!_facialPanel) {
        _facialPanel = [[HXFacialSelectionPanel alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_facialPanel];
    }
    return _facialPanel;
}

@end
