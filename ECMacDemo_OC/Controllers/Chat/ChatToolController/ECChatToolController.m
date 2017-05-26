//
//  ECChatToolController.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/24.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECChatToolController.h"
#import "ECVoiceCallViewController.h"
#import "ECVideoCallViewController.h"
#import "ECEmojiController.h"
#import "ECChatToolView.h"
#import "ECMessage.h"
#import "ECTextMessageBody.h"
#import "ECDevice.h"

#import "DeviceChatHelper.h"
#import <AVFoundation/AVFoundation.h>

#define marginH 200

@interface ECChatToolController ()<NSTextViewDelegate> {
    NSInteger voiceBtnSelected;
}

@property (weak) IBOutlet ECChatToolView *toolView;
@property (unsafe_unretained) IBOutlet NSTextView *inputView;

@property (weak) IBOutlet NSImageView *voiceImageView;
@property (weak) IBOutlet NSTextField *voiceTxt;

@property (nonatomic, strong) ECEmojiController  *emojiVC;
@property (nonatomic, strong) NSString           *sessionId;
@property (nonatomic, strong) NSAttributedString *emoString;
@end

@implementation ECChatToolController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    voiceBtnSelected = 0;
    
    NSPressGestureRecognizer *gesture = [[NSPressGestureRecognizer alloc] initWithTarget:self action:@selector(gestureAction:)];
    gesture.minimumPressDuration = 1;
    [self.voiceImageView addGestureRecognizer:gesture];
    
    [self addNotification];
}

- (void)gestureAction:(NSPressGestureRecognizer *)ges {
    switch (ges.state) {
        case NSGestureRecognizerStateBegan: {
            
            static int seedNum = 0;
            if(seedNum >= 1000)
                seedNum = 0;
            seedNum++;
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
            NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
            NSString *file = [NSString stringWithFormat:@"tmp%@%03d.amr", currentDateStr, seedNum];
            
            ECVoiceMessageBody * messageBody = [[ECVoiceMessageBody alloc] initWithFile:[[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:file] displayName:file];
            
            [[ECDevice sharedInstance].messageManager startVoiceRecording:messageBody error:^(ECError *error, ECVoiceMessageBody *messageBody) {
                NSLog(@"start voice && description --- %@ errCode --- %ld",error.description,(long)error.errorCode);
            }];
        }
            break;
            
        case NSGestureRecognizerStateEnded: {
            
            __weak __typeof(self)weakSelf = self;
            [[ECDevice sharedInstance].messageManager stopVoiceRecording:^(ECError *error, ECVoiceMessageBody *messageBody) {
                __strong __typeof(weakSelf)strongSelf = weakSelf;
                
                if (error.errorCode == 200) {
                    [[DeviceChatHelper sharedInstance] sendMediaMessage:messageBody to:strongSelf.sessionId];
                } else {
                    NSLog(@"end voice && description --- %@ errCode --- %ld",error.description,(long)error.errorCode);
                }
            }];
        }
            break;
        default:
            break;
    }
}

- (void)addNotification {
    [[NSNotificationCenter defaultCenter] addObserverForName:KNOTIFICATION_onClickSession object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.sessionId = note.object;
        self.toolView.voiceCallBtn.hidden = self.toolView.videoCallBtn.hidden = [self.sessionId hasPrefix:@"g"]?YES:NO;
    }];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:KNOTIFICATION_SendMessageCompletion object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        self.inputView.string = @"";
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(emoSelect:) name:EmotionSelectNotification object:nil];
}

- (void)emoSelect:(NSNotification *)noti {
    [self dismissViewController:_emojiVC];
    self.inputView.string = _inputView.string.length?[NSString stringWithFormat:@"%@%@",_inputView.string,noti.object]:noti.object;
}

- (IBAction)emojiBtnClicked:(NSButton *)sender {
    NSRect rect = [sender convertRect:sender.frame fromView:self.view];
    rect.origin.x = sender.frame.origin.x;
    rect.origin.y +=sender.frame.size.height/2.0f;
    ECEmojiController *vc = [[ECEmojiController alloc] init];
    vc.view.frame = CGRectMake(0, 0, 400, 260);
    _emojiVC = vc;
    [self presentViewController:vc asPopoverRelativeToRect:rect ofView:self.view
                  preferredEdge:(NSRectEdgeMinY|NSRectEdgeMaxX) behavior:NSPopoverBehaviorTransient];
}

- (IBAction)fileBtnClicked:(id)sender {
    NSOpenPanel *openDlg = [NSOpenPanel openPanel];
    openDlg.canChooseFiles = YES ;
    openDlg.canChooseDirectories = YES;
    openDlg.allowsMultipleSelection = NO;
    openDlg.allowedFileTypes = @[@"png"];
    
    [openDlg beginWithCompletionHandler: ^(NSInteger result){
        if(result==NSFileHandlingPanelOKButton){
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated"
            NSArray *fileURLs = [openDlg filenames];
            NSString *imagePath = fileURLs.firstObject;
            ECImageMessageBody *mediaBody = [[ECImageMessageBody alloc] initWithFile:imagePath displayName:imagePath.lastPathComponent];
            [[DeviceChatHelper sharedInstance] sendMediaMessage:mediaBody to:self.sessionId];
#pragma clang diagnostic pop
        }
    }];
}

- (IBAction)voiceBtnClicked:(id)sender {
    voiceBtnSelected ++;
    if (voiceBtnSelected%2 == 1) {
        self.voiceImageView.hidden = self.voiceTxt.hidden = NO;
    }else {
        self.voiceImageView.hidden = self.voiceTxt.hidden = YES;
    }
}

- (IBAction)voiceCallBtnClicked:(id)sender {
    ECVoiceCallViewController *callVC = [ECVoiceCallViewController new];
    callVC.sessionId = self.sessionId;
    [self presentViewControllerAsModalWindow:callVC];
}

- (IBAction)videoCallBtnClicked:(id)sender {
    ECVideoCallViewController *videoVC = [ECVideoCallViewController new];
    videoVC.sessionId = self.sessionId;
    [self presentViewControllerAsModalWindow:videoVC];
}

#pragma mark - NSTextViewDelegate
-(BOOL)textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (commandSelector == @selector(insertNewline:)) {
        if (textView.string.length) {
            [[DeviceChatHelper sharedInstance] sendTextMessage:textView.string to:self.sessionId];
        }
        return true;
    }
    return false;
}

@end
