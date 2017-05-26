/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * Created by james <https://github.com/mystcolor> on 9/28/11.
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "SDWebImageDecoder.h"
#import "NSImage+MultiFormat.h"

@implementation UIImage (ForceDecode)

+ (UIImage *)decodedImageWithImage:(UIImage *)image {
    
    NSData *imageData = [self dataRepresentationForType:(NSString *)kUTTypeJPEG compression:0.6 image:image];
//    NSLog(@"----压缩后的大小%zd",imageData.length);
    
    NSImage *resultImage = [[NSImage alloc] initWithDataIgnoringOrientation:imageData];
    
    return resultImage;
}



+ (NSData *)dataRepresentationForType:(NSString *)type compression:(CGFloat)compressionQuality image:(NSImage *)image {
    
    NSBitmapImageRep *bitMapRep = [image bitmapImageRepresentation];
    CGImageRef imageRef = bitMapRep.CGImage;
    
    NSMutableData *mutableData = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((__bridge CFMutableDataRef)mutableData, (__bridge CFStringRef)type, 1, NULL);
    
    NSDictionary *properties = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:compressionQuality], kCGImageDestinationLossyCompressionQuality, nil];
    
    CGImageDestinationAddImage(destination, imageRef, (__bridge CFDictionaryRef)properties);
    
    CGImageDestinationFinalize(destination);
    CFRelease(destination);
    return mutableData;
}


@end
