//
//  ECRevokeMessageBody.h
//  ECSDKDemo_OC
//
//  Created by huangjue on 16/6/12.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import "ECMessageBody.h"

@interface ECRevokeMessageBody : ECMessageBody

@property (nonatomic, copy) NSString *text;

-(instancetype)initWithText:(NSString*)text;
@end
