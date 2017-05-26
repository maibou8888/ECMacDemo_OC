//
//  ECContactModel.h
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/23.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ECContactModel : NSObject

@property (nonatomic , assign) BOOL isDiscuss;
@property (nonatomic ,   copy) NSString *groupId;
@property (nonatomic , retain) NSString *nodeName;
@property (nonatomic , retain) NSString *nodePhone;
@property (nonatomic , retain) NSMutableArray<ECContactModel *> *nodes;

@end
