//
//  UIImage+MultiFormat.m
//  SDWebImage
//
//  Created by Olivier Poitrey on 07/06/13.
//  Copyright (c) 2013 Dailymotion. All rights reserved.
//

#import "NSImage+MultiFormat.h"
#import "NSImage+GIF.h"
#import <ImageIO/ImageIO.h>
#import  <CoreGraphics/CoreGraphics.h>
@implementation UIImage (MultiFormat)

+ (UIImage *)sd_imageWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    return [[UIImage alloc] initWithDataIgnoringOrientation:data];
}



- (NSBitmapImageRep *)bitmapImageRepresentation {
    NSArray * imageReps = [self representations];
    float width = 0;
    float height = 0;
    
    for (NSImageRep * imageRep in imageReps) {
        if ([imageRep pixelsWide] > width) width = [imageRep pixelsWide];
        if ([imageRep pixelsHigh] > height) height = [imageRep pixelsHigh];
    }
    
    if(width < 1 || height < 1)
        return nil;
    
    NSBitmapImageRep *rep = [[NSBitmapImageRep alloc]
                             initWithBitmapDataPlanes: NULL
                             pixelsWide: width
                             pixelsHigh: height
                             bitsPerSample: 8
                             samplesPerPixel: 4
                             hasAlpha: YES
                             isPlanar: NO
                             colorSpaceName: NSDeviceRGBColorSpace
                             bytesPerRow: 0
                             bitsPerPixel: 0];
    
    NSGraphicsContext *ctx = [NSGraphicsContext graphicsContextWithBitmapImageRep:rep];
    [NSGraphicsContext saveGraphicsState];
    [NSGraphicsContext setCurrentContext: ctx];
    [self drawInRect:NSMakeRect(0, 0, width, height) fromRect:NSZeroRect operation:NSCompositeCopy fraction:1.0];
    [ctx flushGraphics];
    [NSGraphicsContext restoreGraphicsState];
    
    return rep;
}


@end
