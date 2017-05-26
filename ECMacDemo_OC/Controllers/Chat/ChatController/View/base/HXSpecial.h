//
//  HXSpecial.h
//  DingDing_Project
//
//  Created by hanxiaoqing on 2016/11/30.
//  Copyright © 2016年 HXQ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXSpecial : NSObject
/** 这段特殊文字的内容 */
@property (nonatomic, copy) NSString *text;
/** 这段特殊文字的范围 */
@property (nonatomic, assign) NSRange range;
/** 这段特殊文字的矩形框(要求数组里面存放CGRect) */
@property (nonatomic, strong) NSArray *rects;
@end
