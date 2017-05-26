//
//  ECContactModel.m
//  ECMacDemo_OC
//
//  Created by 王明哲 on 2017/5/23.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECContactModel.h"

@implementation ECContactModel

-(NSMutableArray *)nodes {
    if (!_nodes) {
        _nodes = [NSMutableArray array];
    }
    
    return _nodes;
}

@end
