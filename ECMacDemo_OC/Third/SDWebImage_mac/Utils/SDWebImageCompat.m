//
//  SDWebImageCompat.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 11/12/12.
//  Copyright (c) 2012 Dailymotion. All rights reserved.
//

#import "SDWebImageCompat.h"

#if !__has_feature(objc_arc)
#error SDWebImage is ARC only. Either turn on ARC for the project or use -fobjc-arc flag
#endif

// mac os NSImage 没有对scale的处理方法因此 直接返回
inline UIImage *SDScaledImageForKey(NSString *key, UIImage *image) {
    if (!image) {
        return nil;
    }
    return image;
}

NSString *const SDWebImageErrorDomain = @"SDWebImageErrorDomain";
