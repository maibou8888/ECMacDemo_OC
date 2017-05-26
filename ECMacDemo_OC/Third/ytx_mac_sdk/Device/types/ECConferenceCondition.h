//
//  ECConferenceCondition.h
//  CCPiPhoneSDK
//
//  Created by jiazy on 2017/2/17.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECConferenceInfo.h"
#import "ECStruct.h"

typedef NS_ENUM(NSUInteger,ECConferenceSearchType) {
    
    /** 创建的会议 */
    ECConferenceSearchType_Create = 1,
    
    /** 参与的会议 */
    ECConferenceSearchType_Participate = 2,
    
    /** 创建和参与的会议 */
    ECConferenceSearchType_All = 3,
};

/**
 *  会议获取条件类
 */
@interface ECConferenceCondition : NSObject

/**
 @brief 创建时间起始点 yyyy-MM-dd HH:mm:ss
 */
@property (nonatomic, copy) NSString* createTimeBegin;

/**
 @brief 创建时间终点 yyyy-MM-dd HH:mm:ss
 */
@property (nonatomic, copy) NSString* createTimeEnd;

/**
 @brief 会议类型
 */
@property (nonatomic, assign) ECConferenceType confType;

/**
 @brief 会议类型
 */
@property (nonatomic, strong) ECAccountInfo* member;

/**
 @brief 会议类型
 */
@property (nonatomic, assign) ECConferenceSearchType searchType;

/**
 @brief 预留
 */
@property (nonatomic, copy) NSString* appData;

@end
