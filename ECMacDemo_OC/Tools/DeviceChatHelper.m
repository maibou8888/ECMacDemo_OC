//
//  DeviceChatHelper.m
//  ECSDKDemo_OC
//
//  Created by jiazy on 14/12/15.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import "DeviceChatHelper.h"
#import "ECUserStateMessageBody.h"
#import "IMMsgDBAccess.h"
#import "DeviceDBHelper.h"

@implementation DeviceChatHelper
{
    SystemSoundID sendSound;
}

+(DeviceChatHelper*)sharedInstance{
    static dispatch_once_t DeviceChatHelperOnce;
    static DeviceChatHelper *deviceChatHelper;
    dispatch_once(&DeviceChatHelperOnce, ^{
        deviceChatHelper = [[DeviceChatHelper alloc] init];
    });
    return deviceChatHelper;
}

-(ECMessage*)sendTextMessage:(NSString*)text to:(NSString*)to{
    
    return [self sendTextMessage:text to:to withUserData:text atArray:nil];
}

-(ECMessage*)sendTextMessage:(NSString*)text to:(NSString*)to withUserData:(NSString*)userData atArray:(NSArray*)atArray{
    
    ECTextMessageBody *messageBody = [[ECTextMessageBody alloc] initWithText:text];
    messageBody.atArray = [NSArray arrayWithArray:atArray];
    ECMessage *message = [[ECMessage alloc] initWithReceiver:to body:messageBody];
    message.userData = userData;
    message.from = [[NSUserDefaults standardUserDefaults] objectForKey:lasttimeuser];

    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval tmp =[date timeIntervalSince1970]*1000;
    
#warning 入库前设置本地时间，以本地时间排序和以本地时间戳获取本地数据库缓存数据
    message.timestamp = [NSString stringWithFormat:@"%lld", (long long)tmp];
    
    [[ECDevice sharedInstance].messageManager sendMessage:message progress:self completion:^(ECError *error, ECMessage *amessage) {
        
        if (error.errorCode == ECErrorType_NoError) {
            NSLog(@"--- 发送消息成功 --");
            
        } else if (error.errorCode == ECErrorType_Have_Forbid || error.errorCode == ECErrorType_File_Have_Forbid) {
            [ECCommonTools showAlertOnWindow:[AppDelegate shareInstanced].window titles:@[@"确定"] msgText:@"提示" infoText:@"您已被禁言"
                                       style:NSAlertStyleWarning completionHandler:^(NSModalResponse returnCode) {}];
            
        } else if (error.errorCode == ECErrorType_ContentTooLong) {
            [ECCommonTools showAlertOnWindow:[AppDelegate shareInstanced].window titles:@[@"确定"] msgText:@"提示"
                                    infoText:error.errorDescription style:NSAlertStyleWarning
                           completionHandler:^(NSModalResponse returnCode) {}];
        }
        
        [[IMMsgDBAccess sharedInstance] updateState:message.messageState ofMessageId:message.messageId andSession:message.sessionId];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SendMessageCompletion object:nil userInfo:@{KErrorKey:error, KMessageKey:amessage}];
    }];
    
    [[DeviceDBHelper sharedInstance] addNewMessage:message andSessionId:message.sessionId];
    
    return message;
}

-(ECMessage*)sendMediaMessage:(ECFileMessageBody*)mediaBody to:(NSString*)to withUserData:(NSString*)userData {
    
    ECMessage *message = [[ECMessage alloc] initWithReceiver:to body:mediaBody];
    message.userData = userData;
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval tmp =[date timeIntervalSince1970]*1000;
    
#warning 入库前设置本地时间，以本地时间排序和以本地时间戳获取本地数据库缓存数据
    message.timestamp = [NSString stringWithFormat:@"%lld", (long long)tmp];
    message.from = [[NSUserDefaults standardUserDefaults] objectForKey:lasttimeuser];
    
    [[ECDevice sharedInstance].messageManager sendMessage:message progress:self completion:^(ECError *error, ECMessage *message) {
        
        if (error.errorCode == ECErrorType_NoError) {
            NSLog(@"--- 发送图片成功 --");

        } else if (error.errorCode == ECErrorType_Have_Forbid || error.errorCode == ECErrorType_File_Have_Forbid) {
            [ECCommonTools showAlertOnWindow:[AppDelegate shareInstanced].window titles:@[@"确定"] msgText:@"提示" infoText:@"您已被禁言"
                                       style:NSAlertStyleWarning completionHandler:^(NSModalResponse returnCode) {}];
            
        } else if (error.errorCode == ECErrorType_ContentTooLong) {
            [ECCommonTools showAlertOnWindow:[AppDelegate shareInstanced].window titles:@[@"确定"] msgText:@"提示"
                                    infoText:error.errorDescription style:NSAlertStyleWarning
                           completionHandler:^(NSModalResponse returnCode) {}];
        }
        
        [[IMMsgDBAccess sharedInstance] updateState:message.messageState ofMessageId:message.messageId andSession:message.sessionId];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SendMessageCompletion object:nil userInfo:@{KErrorKey:error, KMessageKey:message}];
    }];
    
    NSLog(@"DeviceChatHelper sendMediaMessage messageid=%@",message.messageId);
    [[DeviceDBHelper sharedInstance] addNewMessage:message andSessionId:message.sessionId];
    
    return message;
}

-(ECMessage*)sendMediaMessage:(ECFileMessageBody*)mediaBody to:(NSString*)to{
    
    ECMessage *message = [[ECMessage alloc] initWithReceiver:to body:mediaBody];
    message.userData = @"";
    NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval tmp =[date timeIntervalSince1970]*1000;
    
#warning 入库前设置本地时间，以本地时间排序和以本地时间戳获取本地数据库缓存数据
    message.timestamp = [NSString stringWithFormat:@"%lld", (long long)tmp];
    message.from = [[NSUserDefaults standardUserDefaults] objectForKey:lasttimeuser];
    
    [[ECDevice sharedInstance].messageManager sendMessage:message progress:self completion:^(ECError *error, ECMessage *amessage) {
        
        if (error.errorCode == ECErrorType_NoError) {
            NSLog(@"--- 发送文件成功 --");
            
        } else if (error.errorCode == ECErrorType_Have_Forbid || error.errorCode == ECErrorType_File_Have_Forbid) {
            [ECCommonTools showAlertOnWindow:[AppDelegate shareInstanced].window titles:@[@"确定"] msgText:@"提示" infoText:@"您已被禁言"
                                       style:NSAlertStyleWarning completionHandler:^(NSModalResponse returnCode) {}];
            
        } else if (error.errorCode == ECErrorType_ContentTooLong) {
            [ECCommonTools showAlertOnWindow:[AppDelegate shareInstanced].window titles:@[@"确定"] msgText:@"提示"
                                    infoText:error.errorDescription style:NSAlertStyleWarning
                           completionHandler:^(NSModalResponse returnCode) {}];
        }
        
        [[IMMsgDBAccess sharedInstance] updateState:amessage.messageState ofMessageId:message.messageId andSession:message.sessionId];
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_SendMessageCompletion object:nil userInfo:@{KErrorKey:error, KMessageKey:amessage}];
    }];
    
    NSLog(@"DeviceChatHelper sendMediaMessage messageid=%@",message.messageId);
    
    [[DeviceDBHelper sharedInstance] addNewMessage:message andSessionId:message.sessionId];
    
    return message;
}

-(void)downloadMediaMessage:(ECMessage*)message andCompletion:(void(^)(ECError *error, ECMessage* message))completion{
    
    ECFileMessageBody *mediaBody = (ECFileMessageBody*)message.messageBody;
    mediaBody.localPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:mediaBody.displayName];
    
    [[ECDevice sharedInstance].messageManager downloadMediaMessage:message progress:self completion:^(ECError *error, ECMessage *message) {
        if (error.errorCode == ECErrorType_NoError) {
            [[IMMsgDBAccess sharedInstance] updateMessageLocalPath:message.messageId withPath:mediaBody.localPath withDownloadState:((ECFileMessageBody*)message.messageBody).mediaDownloadStatus andSession:message.sessionId];
        } else {
            mediaBody.localPath = nil;
            [[IMMsgDBAccess sharedInstance] updateMessageLocalPath:message.messageId withPath:@"" withDownloadState:((ECFileMessageBody*)message.messageBody).mediaDownloadStatus andSession:message.sessionId];
        }
        
        if (completion != nil) {
            completion(error, message);
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_DownloadMessageCompletion object:nil userInfo:@{KErrorKey:error, KMessageKey:message}];
    }];
}
@end
