//
//  ECVideoCallViewController.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/16.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECVideoCallViewController.h"

@interface ECVideoCallViewController () {
    int hhInt;
    int mmInt;
    int ssInt;
    NSTimer  *timer;
}
@property (weak) IBOutlet NSLayoutConstraint *localLeading;
@property (weak) IBOutlet NSLayoutConstraint *localTop;
@property (weak) IBOutlet NSLayoutConstraint *localWidth;
@property (weak) IBOutlet NSLayoutConstraint *localHeight;

@property (weak) IBOutlet NSView *localView;
@property (weak) IBOutlet NSView *remoteView;
@property (weak) IBOutlet NSTextField *nickLabel;
@property (weak) IBOutlet NSTextField *msgLabel;

- (IBAction)hangUpBtnClicked:(id)sender;
@end

@implementation ECVideoCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hhInt = 0;
    mmInt = 0;
    ssInt = 0;
    
    self.title = @"视频通话";
    self.view.wantsLayer = YES;
    self.nickLabel.stringValue = self.sessionId;
    self.localView.layer.backgroundColor = [NSColor clearColor].CGColor;
    self.remoteView.layer.backgroundColor = [NSColor clearColor].CGColor;
    self.view.layer.backgroundColor = [NSColor colorWithRed:50/255.0 green:50/255.0 blue:50/255.0 alpha:1].CGColor;
    
    [self makeVideoCall];
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    CGSize settingSize = CGSizeMake(576, 324);
    
    NSWindow *currentVcInWindow = self.view.window;
    CGRect windowF = currentVcInWindow.frame;
    [currentVcInWindow setFrame:CGRectMake(NSMinX(windowF), NSMinY(windowF), settingSize.width, settingSize.height) display:YES];
    currentVcInWindow.minSize = settingSize;
    currentVcInWindow.maxSize = settingSize;
}

#pragma mark - private
- (void)makeVideoCall {
    [[ECDevice sharedInstance].VoIPManager setVideoView:self.remoteView andLocalView:self.localView];
    
    if (self.callId.length) {
        NSInteger ret = [[ECDevice sharedInstance].VoIPManager acceptCall:self.callId withType:VIDEO];
        if (ret != 0)   [self back];
    }else {
        self.callId = [[ECDevice sharedInstance].VoIPManager makeCallWithType:VIDEO andCalled:self.sessionId];
        if (self.callId.length <= 0) self.msgLabel.stringValue = @"对方不在线或网络不给力";
        else self.msgLabel.stringValue = @"正在等待对方接受邀请......";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCallEvents:)
                                                 name:KNOTIFICATION_onCallEvent object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resizeRemoteView:)
                                                 name:KNOTIFICATION_getRemoteSize object:nil];
}

- (void)onCallEvents:(NSNotification *)notification {
    VoIPCall* voipCall = notification.object;
    
    switch (voipCall.callStatus) {
        case ECallProceeding:
            self.msgLabel.stringValue = @"呼叫中...";
            break;
            
        case ECallAlerting:
            self.msgLabel.stringValue = @"等待对方接听";
            break;
            
        case ECallStreaming: {
            self.msgLabel.stringValue = @"00:00";
            self.localLeading.constant = 428;
            self.localTop.constant = 20;
            self.localWidth.constant = 128;
            self.localHeight.constant = 72;
            
            if (![timer isValid]) {
                timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateRealmsgLabel) userInfo:nil repeats:YES];
                [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
                [timer fire];
            }
        }
            break;
            
        case ECallFailed: {
            if( voipCall.reason == ECErrorType_NoResponse) {
                self.msgLabel.stringValue = @"网络不给力";
            } else if ( voipCall.reason == ECErrorType_CallBusy || voipCall.reason == ECErrorType_Declined ) {
                self.msgLabel.stringValue = @"您拨叫的用户正忙，请稍后再拨";
            } else if ( voipCall.reason == ECErrorType_OtherSideOffline) {
                self.msgLabel.stringValue = @"对方不在线";
            } else if ( voipCall.reason == ECErrorType_CallMissed ) {
                self.msgLabel.stringValue = @"呼叫超时";
            } else if ( voipCall.reason == ECErrorType_SDKUnSupport) {
                self.msgLabel.stringValue = @"该版本不支持此功能";
            } else if ( voipCall.reason == ECErrorType_CalleeSDKUnSupport ) {
                self.msgLabel.stringValue = @"对方版本不支持音频";
            } else {
                self.msgLabel.stringValue = @"呼叫失败";
            }
            
            NSTimer *tmp = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:tmp forMode:NSRunLoopCommonModes];
        }
            break;
            
        case ECallEnd: {
            self.msgLabel.stringValue = @"正在挂机...";
            NSTimer *tmp = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:tmp forMode:NSRunLoopCommonModes];
        }
            break;
            
        default:
            break;
    }
}

- (void)resizeRemoteView:(NSNotification *)noti {
    NSDictionary *sizeDic = noti.object;
    CGFloat width  = [[sizeDic objectForKey:@"w"] floatValue];
    CGFloat height = [[sizeDic objectForKey:@"h"] floatValue];
    if (height > 324) {
        height = 324;
        width  = 324*width/height;
    }
    
    self.remoteView.frame = CGRectMake(288 - width/2, 162 - height/2, width, height);
}

- (void)updateRealmsgLabel {
    ssInt +=1;
    if (ssInt >= 60) {
        mmInt += 1;
        ssInt -= 60;
        if (mmInt >=  60) {
            hhInt += 1;
            mmInt -= 60;
            if (hhInt >= 24) {
                hhInt = 0;
            }
        }
    }
    
    if (hhInt > 0) {
        self.msgLabel.stringValue = [NSString stringWithFormat:@"%02d:%02d:%02d",hhInt,mmInt,ssInt];
    } else {
        self.msgLabel.stringValue = [NSString stringWithFormat:@"%02d:%02d",mmInt,ssInt];
    }
}

- (void)back {
    if ([timer isValid]) {
        [timer invalidate];
        timer = nil;
    }
    
    [[ECDevice sharedInstance].VoIPManager releaseCall:self.callId];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self dismissViewController:self];
}

#pragma mark - xib action
- (IBAction)hangUpBtnClicked:(id)sender {
    [self back];
}
@end
