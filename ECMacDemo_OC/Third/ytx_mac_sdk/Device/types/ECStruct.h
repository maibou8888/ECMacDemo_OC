//
//  ECStruct.h
//  CCPiPhoneSDK
//
//  Created by jiazy on 2017/2/18.
//  Copyright © 2017年 ronglian. All rights reserved.
//

#ifndef ECStruct_h
#define ECStruct_h

#include <CoreGraphics/CGBase.h>

/**
 *  分页信息
 */
struct CGPage {
    
    /**
     @brief 每页数量
     */
    NSInteger size;
    
    /**
     @brief 页码
     */
    NSInteger number;
};
typedef struct CGPage CGPage;

CG_INLINE CGPage
CGPageMake(NSInteger number, NSInteger size)
{
    CGPage page;
    page.number = number;
    page.size = size;
    return page;
}

#endif /* ECStruct_h */
