//
//  AppDelegate.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/17.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()<NSTableViewDelegate,NSTableViewDataSource>

@end

@implementation AppDelegate

+ (instancetype)shareInstanced {
    static dispatch_once_t onceToken;
    static AppDelegate *appdele = nil;
    dispatch_once(&onceToken, ^{
        appdele = [[[self class] alloc] init];
    });
    return appdele;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.window = [[NSWindow alloc] init];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    EC_MacAppLog(@"%@",self.window);
//    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"NSConstraintBasedLayoutVisualizeMutuallyExclusiveConstraints"];
}

- (IBAction)createNewWindow:(id)sender {
    NSString *executablePath = [[NSBundle mainBundle] executablePath];
    NSTask *task    = [[NSTask alloc] init];
    task.launchPath = executablePath;
    [task launch];
}

@end
