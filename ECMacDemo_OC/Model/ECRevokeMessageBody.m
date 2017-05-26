//
//  ECRevokeMessageBody.m
//  ECSDKDemo_OC
//
//  Created by huangjue on 16/6/12.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import "ECRevokeMessageBody.h"

@implementation ECRevokeMessageBody
-(instancetype)initWithText:(NSString*)text {
    self = [super init];
    if (self) {
        _text = text;
    }
    return self;
}
@end
