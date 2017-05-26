//
//  ECMcmCmdMessage.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 16/1/9.
//  Copyright © 2016年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECMcmCmdMessage : NSObject
@property (nonatomic, assign) NSInteger cmdEvent;
@property (nonatomic, copy) NSString *osAccount;
@property (nonatomic, copy) NSString *userAccount;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *msgJsonData;
@property (nonatomic, copy) NSDictionary *dataDic;
@end
