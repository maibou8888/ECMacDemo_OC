//
//  UIImage+GIF.h
//  LBGIFImage
//
//  Created by Laurin Brandner on 06.01.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <AppKit/AppKit.h>

@interface NSImage (GIF)

+ (NSImage *)sd_animatedGIFNamed:(NSString *)name;

+ (NSImage *)sd_animatedGIFWithData:(NSData *)data;

- (NSImage *)sd_animatedImageByScalingAndCroppingToSize:(CGSize)size;

@end
