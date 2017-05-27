//
//  ECMainWindowController.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/19.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECMainWindowController.h"
#import "ECSessionController.h"
#import "ECNavController.h"
#import "ECNavView.h"
#import "ECMainController.h"
#import "ECVoiceCallViewController.h"
#import "ECGroupListController.h"
#import "ECAddContactVC.h"
#import "DeviceDBHelper.h"

#define NavH 56.0f
@interface ECMainWindowController ()<NSWindowDelegate>
@property (nonatomic, strong) ECMainController *mainVC;
@end

@implementation ECMainWindowController
{
    CGFloat _oldRightSplitW;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self = [[NSStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateControllerWithIdentifier:NSStringFromClass([self class])];
        [self.window setAnimationBehavior:NSWindowAnimationBehaviorDocumentWindow];
        [self.window makeFirstResponder:nil];
    }
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.window.title = @"";
    [self.window center];
    [self.window setMovableByWindowBackground:YES];
    [self showWindow:[AppDelegate shareInstanced]];
    self.mainVC = (ECMainController *)self.contentViewController;

    [self prepareUI];
    [self registerNotify];
    
    NSArray *array = [[DeviceDBHelper sharedInstance] getMyCustomSession];
    if (array.count) {
        ECSession *tmpSession = array[0];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onClickSession object:tmpSession.sessionId];
    }
}

#pragma mark - 基本方法
- (void)prepareUI {
    
    __weak typeof(self)weakSelf = self;
    ECNavController *nav = [[ECNavController alloc] init];
    [self.mainVC.NavView addSubview:nav.view];
    
    ECNavView *naview = (ECNavView *)nav.view;
    naview.block1 = ^(id sender) {
        self.mainVC.mainSplitView.hidden = NO;
        self.mainVC.contactSplit.hidden = YES;
    };
    naview.block2 = ^(id sender) {
        self.mainVC.mainSplitView.hidden = YES;
        self.mainVC.contactSplit.hidden = NO;
    };
    [naview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.mainVC.NavView);
    }];
    
    ECSessionController *sessionVC = [[ECSessionController alloc] init];
    [self.mainVC.leftView addSubview:sessionVC.view];
    
    [sessionVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(weakSelf.mainVC.leftView);
    }];
    
    ECGroupListController *groupVC = [[ECGroupListController alloc] init];
    [self.mainVC.rightSplitView.rightRigV addSubview:groupVC.view];
    [groupVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainVC.rightSplitView.rightRigV);
    }];
    
    //contact
    ECAddContactVC *addContactVC = [ECAddContactVC new];
    [self.mainVC addChildViewController:addContactVC];
    [self.mainVC.contactLeftView addSubview:addContactVC.view];
    
    [addContactVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.mainVC.contactLeftView);
    }];
}

#pragma mark - 通知
- (void)registerNotify {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hiddenNoti:)
                                                 name:KNOTIFICATION_onClickSession object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(presentVoiceCallVC:)
                                                 name:KNOTIFICATION_onCallIncoming object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:KNOTIFICATION_selectContact object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      self.mainVC.mainSplitView.hidden = NO;
                                                      self.mainVC.contactSplit.hidden = YES;
    }];
}

#pragma mark - 通知的方法
- (void)hiddenNoti:(NSNotification *)noti {
    self.mainVC.rightSplitView.hidden = NO;
    self.mainVC.rightSplitView.isHiddenR = [noti.object hasPrefix:@"g"]?NO:YES;
    [self.mainVC.rightSplitView adjustSubviews];
}

- (void)presentVoiceCallVC:(NSNotification *)noti {
    ECVoiceCallViewController *callVC = [ECVoiceCallViewController new];
    callVC.callId = noti.object[@"CALLID"];
    callVC.sessionId = noti.object[@"CALLER"];
    callVC.videoFlag = noti.object[@"VIDEO"];
    [self.contentViewController presentViewControllerAsModalWindow:callVC];
}

#pragma mark - NSWindowDelegate
- (NSSize)windowWillResize:(NSWindow *)sender toSize:(NSSize)frameSize {
    
    frameSize.width = frameSize.width<mainW?mainW:frameSize.width;
    frameSize.height = frameSize.height<mainH?mainH:frameSize.height;
    NSRect rect = self.mainVC.rightSplitView.rightLeftV.frame;
    NSRect rect1 =  self.mainVC.rightSplitView.rightRigV.frame;

    if (frameSize.width>mainW) {
        rect.size.width += (frameSize.width-mainW);
    }
    if (frameSize.height>mainH) {
        rect.size.height += (frameSize.height-mainH);
    }
    
    if (_oldRightSplitW==0)
        _oldRightSplitW = rect1.size.width;
    
    rect1.size = CGSizeMake(_oldRightSplitW, rect1.size.height);

    self.mainVC.rightSplitView.rightLeftV.frame = rect;
    self.mainVC.rightSplitView.rightRigV.frame = rect1;
    [self.mainVC.rightSplitView adjustSubviews];
    return frameSize;
}

@end
