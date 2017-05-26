//
//  ECLoginController.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/17.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECLoginController.h"
#import "ECTextField.h"
#import "ECLgBottomView.h"
#import "ECLoginInfo.h"
#import "ECDevice.h"

#import "DeviceDBHelper.h"
#import "ECDeviceDelegateImpl.h"

typedef void(^AniBlock)();

@interface ECLoginController ()<NSTextFieldDelegate>

@property (nonatomic, strong) NSButton *closeBtn;
@property (nonatomic, strong) NSImageView *iconImgV;
@property (nonatomic, strong) ECTextField *accountF;
@property (nonatomic, strong) ECTextField *pwdF;
@property (nonatomic, strong) NSButton *bottomBtn;
@property (nonatomic, strong) ECLgBottomView *bottomView;
@property (nonatomic, strong) NSButton *lgBtn;
@property (nonatomic, strong) AniBlock aniBlock;
@end

@implementation ECLoginController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.frame = CGRectMake(0, 0, 220, 300);
    [self prepareUI];
}

- (void)prepareUI {
    [self.view addSubview:self.closeBtn];
    [self.view addSubview:self.iconImgV];
    [self.view addSubview:self.accountF];
    [self.view addSubview:self.pwdF];
    [self.view addSubview:self.lgBtn];
    [self.view addSubview:self.bottomBtn];
    [self.view addSubview:self.bottomView];
    
    __weak typeof(self)weakSelf = self;
    [self.closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.view).offset(5.0f);
        make.left.equalTo(weakSelf.view).offset(2.0f);
        make.width.and.height.offset(30.0f);
    }];
    
    [self.iconImgV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.closeBtn.mas_bottom).offset(20.0f);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.width.and.height.offset(80.0f);
    }];
    
    [self.accountF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.iconImgV.mas_bottom).offset(30.0f);
        make.left.equalTo(weakSelf.view.mas_left).offset(30.0f);
        make.right.equalTo(weakSelf.view.mas_right).offset(-30.0f);
        make.height.offset(34.0f);
    }];
    
    [self.pwdF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.accountF.mas_bottom).offset(10.0f);
        make.left.equalTo(weakSelf.accountF.mas_left);
        make.right.equalTo(weakSelf.accountF.mas_right);
        make.height.equalTo(weakSelf.accountF.mas_height);
    }];
    
    [self.lgBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(weakSelf.pwdF.mas_right).offset(20.0f);
        make.top.equalTo(weakSelf.pwdF.mas_top);
        make.bottom.equalTo(weakSelf.pwdF.mas_bottom).offset(-10.0f);
        make.width.offset(60.0f);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(weakSelf.pwdF.mas_bottom).offset(20.0f);
        make.centerX.equalTo(weakSelf.view.mas_centerX);
        make.height.offset(30.0f);
        make.width.offset(160.0f);
    }];

    [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.and.left.and.right.equalTo(weakSelf.view);
        make.height.offset(120.0f);
    }];
}

#pragma mark - 按钮方法
- (void)closeLoginVC:(id)sender {
    exit(0);
}

- (void)clickedBottom:(NSButton *)sender {
    
    BOOL isSelected = sender.tag;

    __weak typeof(self)weakSelf = self;
    if (isSelected) {
        weakSelf.aniBlock = ^() {
            weakSelf.bottomView.hidden = NO;
            weakSelf.bottomView.animator.alphaValue = 0.5f;
        };
    } else {
        weakSelf.aniBlock = ^() {
            weakSelf.bottomView.hidden = YES;
        };
    }
    [NSAnimationContext runAnimationGroup:^(NSAnimationContext * _Nonnull context) {
        context.duration = 1;
        context.allowsImplicitAnimation = YES;
        weakSelf.aniBlock();
    } completionHandler:^{
        
    }];
    
    isSelected = !isSelected;
    sender.tag = isSelected;
}

- (void)loginButtonClick {
    NSCharacterSet *ws = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    NSString *trimmed = [_accountF.stringValue stringByTrimmingCharactersInSet:ws];
    
    if (trimmed.length == 0) {
        [ECCommonTools showAlertOnWindow:self.view.window titles:@[@"确定"] msgText:@"提示" infoText:@"账号为空"
                                   style:NSAlertStyleWarning completionHandler:^(NSModalResponse returnCode) {}];
        return;
    }

    NSString *userName = _accountF.stringValue;
    NSString *password = [_pwdF.stringValue stringByTrimmingCharactersInSet:ws];
    
    if (password.length==0) {
        [ECCommonTools showAlertOnWindow:self.view.window titles:@[@"确定"] msgText:@"提示" infoText:@"密码为空"
                                   style:NSAlertStyleWarning completionHandler:^(NSModalResponse returnCode) {}];
        return;
    }
    
    [self loginWithAccount:userName pwd:password];
}

- (void)loginWithAccount:(NSString *)account pwd:(NSString *)pwd {
    ECLoginInfo * loginInfo = [[ECLoginInfo alloc] init];
    loginInfo.username = account;
    loginInfo.userPassword = pwd;
    loginInfo.appKey = @"20150314000000110000000000000010";
    loginInfo.appToken = @"17E24E5AFDB6D0C1EF32F3533494502B";
    loginInfo.authType = LoginAuthType_NormalAuth;
    loginInfo.mode     = LoginMode_InputPassword;
    
    __weak typeof(self) weakSelf = self;
    [DJProgressHUD showStatus:@"登录中..." FromView:self.view];
    [[ECDevice sharedInstance] login:loginInfo completion:^(ECError *error){
        
        [DJProgressHUD dismiss];
        if (error.errorCode == ECErrorType_NoError) {
            [[DeviceDBHelper sharedInstance] openDataBasePath:account];
            [ECDevice sharedInstance].delegate = [ECDeviceDelegateImpl sharedInstance];
            [[NSUserDefaults standardUserDefaults] setObject:account forKey:lasttimeuser];
            [[NSUserDefaults standardUserDefaults] setObject:pwd forKey:lasttimeuserpwd];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf pushMainController:nil];
            });
            
        } else {
            NSLog(@"登录错误码 --- %ld",(long)error.errorCode);
        }
    }];
}

- (void)pushMainController:(id)sender {
    NSWindowController *mainVC = (NSWindowController *)[[NSClassFromString(@"ECMainWindowController") alloc] init];
    [AppDelegate shareInstanced].window = mainVC.window;
    [mainVC.window makeKeyAndOrderFront:nil];
    
    [self.view.window orderOut:self];
}

#pragma mark - 基本属性
- (NSButton *)closeBtn {
    if (!_closeBtn) {
        _closeBtn = [NSButton buttonWithImage:EC_ImageNamed(@"red-hover") target:self action:@selector(closeLoginVC:)];
        [_closeBtn setBezelStyle:NSBezelStyleRegularSquare];
        [_closeBtn setBordered:NO];
    }
    return _closeBtn;
}

- (NSImageView *)iconImgV {
    if(!_iconImgV) {
        _iconImgV = [[NSImageView alloc] init];
        _iconImgV.image = [NSImage imageNamed:@"wode_touxiang"];
    }
    return _iconImgV;
}

- (NSTextField *)accountF {
    if (!_accountF) {
        _accountF = [[ECTextField alloc] init];
        _accountF.delegate = self;
        
        NSString *account = [[NSUserDefaults standardUserDefaults] objectForKey:lasttimeuser];
        if(EC_MAC_OS_X_10_10) _accountF.placeholderString = NSLocalizedString(@"请输入账号", @"");
        if (account.length) {
            _accountF.stringValue = account;
            [self.pwdF becomeFirstResponder];
        }
    }
    return _accountF;
}

- (NSTextField *)pwdF {
    if (!_pwdF) {
        _pwdF = [[ECTextField alloc] init];
        if(EC_MAC_OS_X_10_10)
            _pwdF.delegate = self;
            _pwdF.placeholderString = NSLocalizedString(@"请输入密码", @"");
    }
    return _pwdF;
}

- (NSButton *)lgBtn {
    if (!_lgBtn) {
        _lgBtn = [NSButton buttonWithImage:EC_ImageNamed(@"LoginButton") target:self action:@selector(loginButtonClick)];
        [_lgBtn setBordered:NO];
    }
    return _lgBtn;
}

- (NSButton *)bottomBtn {
    if (!_bottomBtn) {
        _bottomBtn = [NSButton buttonWithTitle:@" " target:self action:nil];
        [_bottomBtn setBezelStyle:NSRoundedDisclosureBezelStyle];
        _bottomBtn.tag = 1;
    }
    return _bottomBtn;
}

- (ECLgBottomView *)bottomView {
    if (!_bottomView) {
        _bottomView = [[ECLgBottomView alloc] init];
        _bottomView.hidden = YES;
    }
    return _bottomView;
}

#pragma mark - NSTextFieldDelegate
-(BOOL)control:(NSControl *)control textView:(NSTextView *)textView doCommandBySelector:(SEL)commandSelector {
    if (commandSelector == @selector(insertNewline:)) {
        [self loginWithAccount:_accountF.stringValue pwd:_pwdF.stringValue];
        return true;
    }
    return false;
}

@end
