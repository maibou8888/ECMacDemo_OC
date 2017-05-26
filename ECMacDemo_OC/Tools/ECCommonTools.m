//
//  ECCommonTools.m
//  ECMacDemo_OC
//
//  Created by huangjue on 2017/4/18.
//  Copyright © 2017年 com.ronglian.yuntongxun. All rights reserved.
//

#import "ECCommonTools.h"
#import "IMMsgDBAccess.h"

#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>
#import <AddressBook/ABMultiValue.h>
#import "RegexKitLite.h"

@implementation ECCommonTools

+ (NSInteger)systemVersion {
    NSOperatingSystemVersion version = [[NSProcessInfo processInfo] operatingSystemVersion];
    NSInteger majorV = version.majorVersion;
    if (majorV/10 == 0) {
        majorV = majorV*10;
    }
    NSInteger minorV = version.minorVersion;
    if (minorV/10 == 0) {
        minorV = minorV*10;
    }
    
    NSInteger patchV = version.patchVersion;
    if (patchV/10 == 0) {
        patchV = patchV*10;
    }
    
    NSString *systemVersion = [NSString stringWithFormat:@"%ld%ld%ld",(long)majorV, (long)minorV, (long)patchV];
    return systemVersion.integerValue;
}

+ (void)showAlertOnWindow:(NSWindow *)window
                   titles:(NSArray<NSString *> *)titles msgText:(NSString *)msgText infoText:(NSString *)infoText
                    style:(NSAlertStyle)style completionHandler:(void (^)(NSModalResponse returnCode))handler {
    
    NSAlert *alert = [[NSAlert alloc] init];
    if (titles.count)       [alert addButtonWithTitle:titles[0]];
    if (titles.count > 1)   [alert addButtonWithTitle:titles[1]];
    if (titles.count > 2)   [alert addButtonWithTitle:titles[2]];
    
    [alert setMessageText:msgText];
    [alert setInformativeText:infoText];
    [alert setAlertStyle:style];
    
    [alert beginSheetModalForWindow:window
                  completionHandler:^(NSModalResponse returnCode){
                      handler(returnCode);
                  }
     ];
}

+ (NSDictionary *)appConfigDic {
    
    //应用资源文件夹应用信息文件路径
    NSString *appResource = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:AppConfigPlist];
    
    //应用资源文件在设备上的路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *appDocument = [[paths objectAtIndex:0] stringByAppendingPathComponent:AppConfigPlist];
    
    BOOL success = [[NSFileManager defaultManager] fileExistsAtPath:appDocument];
    if (!success){
        
        NSError *error;
        success = [[NSFileManager defaultManager] copyItemAtPath:appResource toPath:appDocument error:&error];
        if (!success){
            NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
        }
    }
    
    //读取设备配置文件 实际开发中，可直接读取应用资源配置文件appResource
    return [[NSMutableDictionary alloc] initWithContentsOfFile:appDocument];
}

+ (NSString*)getOtherNameWithPhone:(NSString*)phone {
    
    if (phone.length <= 0) {
        return @"";
    }
    
    if ([phone isEqualToString:@"10089"]) {
        return @"系统通知";
    }
    
    if ([phone hasPrefix:@"g"]) {
        NSString * name = [[IMMsgDBAccess sharedInstance] getGroupNameOfId:phone];
        if (name.length ==0) {
            
            //请求群组信息
            [[ECDevice sharedInstance].messageManager getGroupDetail:phone completion:^(ECError *error, ECGroup *group) {
                
                if (error.errorCode == ECErrorType_NoError && group.name.length>0) {
                    
                    [[IMMsgDBAccess sharedInstance] addGroupIDs:@[group]];
                    [[NSNotificationCenter defaultCenter] postNotificationName:KNOTIFICATION_onMesssageChanged object:group.groupId];
                }
            }];
            
            return phone;
        } else {
            return name;
        }
    } else {
        
        NSString* name = [[IMMsgDBAccess sharedInstance] getUserName:phone];
        if (name.length>0) {
            return name;
        }
    }
    return phone;
}

+ (void)resizeWithImg:(NSImage *)image w:(CGFloat)w h:(CGFloat)h {
    
    CGFloat newWidth = 120*w/h;
    if (newWidth > 200) {
        newWidth = 200;
    } else if (newWidth < 70) {
        newWidth = 70;
    }
    
    image.size = CGSizeMake(newWidth, 120.0f);
}

//时间显示内容
+ (NSString *)getDateDisplayString:(long long) miliSeconds{
    
    NSTimeInterval tempMilli = miliSeconds;
    NSTimeInterval seconds = tempMilli/1000.0;
    NSDate *myDate = [NSDate dateWithTimeIntervalSince1970:seconds];
    
    NSCalendar *calendar = [ NSCalendar currentCalendar ];
    int unit = NSCalendarUnitDay | NSCalendarUnitMonth |  NSCalendarUnitYear ;
    NSDateComponents *nowCmps = [calendar components:unit fromDate:[ NSDate date ]];
    NSDateComponents *myCmps = [calendar components:unit fromDate:myDate];
    
    NSDateFormatter *dateFmt = [[ NSDateFormatter alloc ] init ];
    if (nowCmps.year != myCmps.year) {
        dateFmt.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    } else {
        if (nowCmps.day==myCmps.day) {
            dateFmt.dateFormat = @"今天 HH:mm:ss";
        } else if ((nowCmps.day-myCmps.day)==1) {
            dateFmt.dateFormat = @"昨天 HH:mm:ss";
        } else {
            dateFmt.dateFormat = @"MM-dd HH:mm:ss";
        }
    }
    return [dateFmt stringFromDate:myDate];
}

+(CGFloat)getWidthWithTime:(NSInteger)time {
    if (time <= 0)
        return 140.0f;
    else if (time <= 2)
        return 80.0f;
    else if (time < 10)
        return (80.0f + 9.0f * (time - 2));
    else if (time < 60)
        return (80.0f + 9.0f * (7 + time / 10));
    return 200.0f;
}

+ (CGFloat)getHeightWithText:(NSString *)text font:(CGFloat)fontSize sizeWidth:(CGFloat)width {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    NSFont *fnt = [NSFont fontWithName:@"HelveticaNeue" size:fontSize];
    CGRect rect = [text boundingRectWithSize:NSMakeSize(width, 1000.0f)
                                     options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                  attributes:@{NSFontAttributeName:fnt} context:nil];
#pragma clang diagnostic pop

    return rect.size.height;
}

+ (NSMutableArray *)getAllAddressBookData {
    NSMutableArray *addressArray = [NSMutableArray array];
    ABAddressBook* addressBook = [ABAddressBook sharedAddressBook];
    NSArray* people = [addressBook people];
    
    for(ABPerson* person in people)
    {
        NSString* firstName = [person valueForKey: kABFirstNameProperty];
        NSString* lastName = [person valueForKey: kABLastNameProperty];
        NSString* entryName = (firstName == NULL && lastName == NULL) ? [person valueForKey: kABOrganizationProperty] : [NSString stringWithFormat:@"%@ %@", (firstName == NULL) ? @"" : firstName, (lastName == NULL) ? @"" : lastName];
        
        ABMutableMultiValue* phones = [[person valueForKey:kABPhoneProperty] mutableCopy];
        
        BOOL hasLogged = NO;
        for(int i = 0 ; i < [phones count] ; i++)
        {
            NSString* phone = [phones valueAtIndex: i];
            // Cleanup Phone Number, removing spaces(\s), dash(‑|-) and parenthesis().
            phone = [phone stringByReplacingOccurrencesOfRegex:@"(\\s|‑|-|\\(|\\))" withString:@""];
            
            if(!hasLogged) {
                if (entryName.length && phone.length) {
                    [addressArray addObject:@{ABName:entryName,ABPhone:phone}];
                }
                hasLogged = YES;
            }
        }
    }
    
    [addressBook save];
    return addressArray;
}

@end
