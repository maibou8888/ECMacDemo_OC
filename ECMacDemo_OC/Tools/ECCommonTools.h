//
//  ECCommonTools.h
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/18.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import <Foundation/Foundation.h>

#define ABName   @"abName"
#define ABPhone  @"abPhone"

@interface ECCommonTools : NSObject

+ (NSInteger)systemVersion;

+ (void)showAlertOnWindow:(NSWindow *)window
                   titles:(NSArray<NSString *> *)titles msgText:(NSString *)msgText infoText:(NSString *)infoText
                    style:(NSAlertStyle)style completionHandler:(void (^)(NSModalResponse returnCode))handlert;

+ (NSDictionary *)appConfigDic;

+ (NSString*)getOtherNameWithPhone:(NSString*)phone;

+ (void)resizeWithImg:(NSImage *)image w:(CGFloat)w h:(CGFloat)h;

+ (NSString *)getDateDisplayString:(long long) miliSeconds;

+(CGFloat)getWidthWithTime:(NSInteger)time;

+ (CGFloat)getHeightWithText:(NSString *)text font:(CGFloat)fontSize sizeWidth:(CGFloat)width;

+ (NSMutableArray *)getAllAddressBookData;

@end
