//
//  ECGroupMatch.h
//  CCPiPhoneSDK
//
//  Created by ronglian on 14/11/7.
//  Copyright (c) 2014年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * 搜索的类型
 */
typedef NS_ENUM(NSUInteger, ECGroupSearchType){
    
    /** 根据GroupId，精确搜索  */
    ECGroupSearchType_GroupId=1,
    
    /** 根据GroupName，模糊搜索，默认值  */
    ECGroupSearchType_GroupName=2,
} ;

/**
 * 群组搜索的条件
 */
@interface ECGroupMatch : NSObject

/**
 @property
 @brief 搜索类型 1: 群组ID  2：群组名称
 */
@property (nonatomic, assign) ECGroupSearchType searchType;

/**
 @property
 @brief name 搜索关键词
 */
@property (nonatomic, copy) NSString *keywords;

/**
 @property
 @brief 分页参数，页数，从1开始，默认是1;(模糊搜索使用)
 */
@property (nonatomic, assign) NSInteger pageNo;

/**
 @property
 @brief 分页参数，每页条数，默认是10；(模糊搜索使用)
 */
@property (nonatomic, assign) NSInteger pageSize;
@end
