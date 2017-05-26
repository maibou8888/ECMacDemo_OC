//
//  ECDeviceDelegateImpl.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/3.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECDeviceDelegateImpl.h"
#import "DeviceChatHelper.h"
#import "DeviceDBHelper.h"
#import "ECVoiceCallViewController.h"

@implementation ECDeviceDelegateImpl

+(ECDeviceDelegateImpl*)sharedInstance {
    static dispatch_once_t DeviceChatHelperOnce;
    static ECDeviceDelegateImpl *deviceDelegateImpl;
    dispatch_once(&DeviceChatHelperOnce, ^{
        deviceDelegateImpl = [[ECDeviceDelegateImpl alloc] init];
    });
    return deviceDelegateImpl;
}

/**
 @brief 接收即时消息代理函数
 @param message 接收的消息
 */
-(void)onReceiveMessage:(ECMessage*)message{
    
    if (message.from.length==0 || message.messageBody.messageBodyType==MessageBodyType_Call) {
        return;
    }
    
    if (message.messageBody.messageBodyType==MessageBodyType_UserState) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"KNOTIFICATION_onUserState" object:message];
        return;
    }
    
#warning 时间全部转换成本地时间
    if (message.timestamp) {
        NSDate* date = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval tmp =[date timeIntervalSince1970]*1000;
        message.timestamp = [NSString stringWithFormat:@"%lld", (long long)tmp];
    }
    
    [[DeviceDBHelper sharedInstance] addNewMessage:message andSessionId:self.sessionId];
    
    //同步过来的发送消息不播放提示音
    if (message.messageState == ECMessageState_Receive) {

    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onMesssageChanged object:message];
    
    MessageBodyType bodyType = message.messageBody.messageBodyType;
    if( bodyType == MessageBodyType_Voice || bodyType == MessageBodyType_Video || bodyType == MessageBodyType_File || bodyType == MessageBodyType_Image || bodyType== MessageBodyType_Preview){
        ECFileMessageBody *body = (ECFileMessageBody*)message.messageBody;
        body.displayName = body.remotePath.lastPathComponent;
        
        if (message.messageBody.messageBodyType == MessageBodyType_Video) {
            
            ECVideoMessageBody *videoBody = (ECVideoMessageBody *)message.messageBody;
            
            if (videoBody.thumbnailRemotePath == nil) {
                videoBody.displayName = videoBody.remotePath.lastPathComponent;
                [[DeviceChatHelper sharedInstance] downloadMediaMessage:message andCompletion:nil];
            }
            
        } else {
            [[DeviceChatHelper sharedInstance] downloadMediaMessage:message andCompletion:nil];
        }
    }
}

//呼叫事件
- (void)onCallEvents:(VoIPCall*)voipCall {
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onCallEvent object:voipCall];
}

- (NSString*)onIncomingCallReceived:(NSString*)callid withCallerAccount:(NSString *)caller withCallerPhone:(NSString *)callerphone withCallerName:(NSString *)callername withCallType:(CallType)calltype {
    
    NSDictionary *paramsDic = nil;
    if(calltype==VIDEO) {
        paramsDic = @{@"CALLID":callid,@"CALLER":caller,@"VIDEO":@"1"};
    } else {
        paramsDic = @{@"CALLID":callid,@"CALLER":caller};
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onCallIncoming object:paramsDic];
    return @"";
}

- (void)onCallVideoRatioChanged:(NSString *)callid andWidth:(NSInteger)width andHeight:(NSInteger)height {
    NSDictionary *remoteSizeDic = @{@"w":@(width),@"h":@(height)};
    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_getRemoteSize object:remoteSizeDic];
}


@end
