//
//  ECRightSplitView.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/24.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECRightSplitView.h"
#import "ECChatMainSplitController.h"
#import "ECGroupListController.h"


@implementation ECRightSplitView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    ECChatMainSplitController *chatMainVC = [[ECChatMainSplitController alloc] init];
    [self.rightLeftV addSubview:chatMainVC.view];
    
    [chatMainVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.rightLeftV);
    }];

//    self.hidden = YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
}

- (void)setIsHiddenR:(BOOL)isHiddenR {
    _isHiddenR = isHiddenR;
    self.rightRigV.hidden = isHiddenR;
}
@end
