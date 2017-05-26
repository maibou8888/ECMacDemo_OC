//
//  ECTalkViewController.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/25.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECTalkViewController.h"
#import "ECSession.h"

@interface ECTalkViewController ()

@property (weak) IBOutlet NSTextField *accountLabel;
- (IBAction)startChatBtnClicked:(NSButton *)sender;
@end

@implementation ECTalkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发起会话";
}

- (IBAction)startChatBtnClicked:(NSButton *)sender {
    if (self.accountLabel.stringValue.length) {
        ECSession *notiSession = [ECSession new];
        notiSession.sessionId = _accountLabel.stringValue;
        [Notification_center postNotificationName:KNOTIFICATION_selectContact object:notiSession];
        
        [self dismissController:self];
    }
}
@end
