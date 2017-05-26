//
//  ECLocationMessageBody.h
//  CCPiPhoneSDK
//
//  Created by admin on 15/12/15.
//  Copyright © 2015年 ronglian. All rights reserved.
//

#import "ECMessageBody.h"
#import <MapKit/MapKit.h>

@interface ECLocationMessageBody : ECMessageBody

/**
 @brief 经纬度信息
 */
@property (nonatomic) CLLocationCoordinate2D coordinate;

/**
 @brief 位置信息
 */
@property (nonatomic, copy) NSString *title;

/**
 @method
 @brief 以经纬度和地理位置构造位置对象
 @result 位置对象
 */
- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate andTitle:(NSString*)title;

@end
