//
//  ECVoiceCallViewController.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/15.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECVoiceCallViewController.h"
#import "ECVideoCallViewController.h"

@interface ECVoiceCallViewController () {
    int hhInt;
    int mmInt;
    int ssInt;
    NSTimer  *timer;
}

@property (weak) IBOutlet NSButton *acceptBtn;
@property (weak) IBOutlet NSLayoutConstraint *hangUpConstraint;
@property (weak) IBOutlet NSImageView *imageView;
@property (weak) IBOutlet NSTextField *nickLabel;
@property (weak) IBOutlet NSTextField *msgLabel;

- (IBAction)hangUpBtnClicked:(id)sender;
- (IBAction)acceptBtnClicked:(id)sender;
@end

@implementation ECVoiceCallViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    hhInt = mmInt = ssInt = 0;
    
    self.view.wantsLayer = YES;
    self.nickLabel.stringValue = self.sessionId;
    self.view.layer.backgroundColor = [NSColor colorWithPatternImage:[NSImage imageNamed:@"voice_video_bg"]].CGColor;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onCallEvents:) name:KNOTIFICATION_onCallEvent object:nil];
    
    //make call
    if (!self.callId.length) {
        self.title = @"音频通话";
        self.acceptBtn.hidden = YES;
        self.hangUpConstraint.constant = 130;
        self.callId = [[ECDevice sharedInstance].VoIPManager makeCallWithType:VOICE andCalled:self.sessionId];
    
    }else {
        if (self.videoFlag.integerValue) {
            self.title = @"视频通话";
            self.msgLabel.stringValue = @"邀请你视频聊天";
        }else {
            self.title = @"音频通话";
            self.msgLabel.stringValue = @"邀请你语音聊天";
        }
    }
}

- (void)viewWillAppear {
    [super viewWillAppear];
    
    CGSize settingSize = CGSizeMake(320, 450);
    
    NSWindow *currentVcInWindow = self.view.window;
    CGRect windowF = currentVcInWindow.frame;
    [currentVcInWindow setFrame:CGRectMake(NSMinX(windowF), NSMinY(windowF), settingSize.width, settingSize.height) display:YES];
    currentVcInWindow.minSize = settingSize;
    currentVcInWindow.maxSize = settingSize;
}

#pragma mark - private
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
            
            if (![timer isValid]) {
                timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateRealtimeLabel) userInfo:nil repeats:YES];
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
            
            NSTimer *t = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:t forMode:NSRunLoopCommonModes];
        }
            break;
            
        case ECallEnd: {
            if ([timer isValid])  {
                [timer invalidate];
                timer = nil;
            }

            self.msgLabel.stringValue = @"正在挂机...";
            NSTimer *tmp = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(back) userInfo:nil repeats:NO];
            [[NSRunLoop currentRunLoop] addTimer:tmp forMode:NSRunLoopCommonModes];
        }
            break;
            
        case ECallTransfered:
            self.msgLabel.stringValue = @"呼叫被转移...";
            break;
        default:
            break;
    }
}

-(void)acceptCall {
    NSInteger ret = [[ECDevice sharedInstance].VoIPManager acceptCall:self.callId withType:0];
    
    if(ret==0) {
        timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(updateRealtimeLabel) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
        [timer fire];
        
    }else{
        self.msgLabel.stringValue = @"接通失败";
        NSTimer *tmp = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(back) userInfo:nil repeats:NO];
        [[NSRunLoop currentRunLoop] addTimer:tmp forMode:NSRunLoopCommonModes];
    }
}

- (void)updateRealtimeLabel {
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

- (IBAction)acceptBtnClicked:(id)sender {
    if (self.videoFlag.integerValue) {
        ECVideoCallViewController *videoVC = [ECVideoCallViewController new];
        videoVC.sessionId = self.sessionId;
        videoVC.callId = self.callId;
        
        [self presentViewControllerAsModalWindow:videoVC];
        [self dismissController:self];
        
    }else {
        self.acceptBtn.hidden = YES;
        self.hangUpConstraint.constant = 130;
        [self acceptCall];
    }
}

@end
