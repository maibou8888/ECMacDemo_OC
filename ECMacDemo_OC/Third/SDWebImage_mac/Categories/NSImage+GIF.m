//
//  UIImage+GIF.m
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSImage+GIF.h"
#import <ImageIO/ImageIO.h>

@implementation NSImage (GIF)

+ (NSImage *)sd_animatedGIFWithData:(NSData *)data {
    return nil;
}

+ (float)sd_frameDurationAtIndex:(NSUInteger)index source:(CGImageSourceRef)source {
    float frameDuration = 0.1f;

    return frameDuration;
}

+ (NSImage *)sd_animatedGIFNamed:(NSString *)name {
    return nil;
}

- (NSImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size {

    return nil;
}

@end
