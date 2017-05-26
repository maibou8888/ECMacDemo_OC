//
//  NSImage+StackBlur.m
//  NeteaseMusic
//
//  Created by han on 3/3/15.
//  Copyright (c) 2015 openthread. All rights reserved.
//

#import "NSImage+StackBlur.h"
#import <CoreGraphics/CoreGraphics.h>

#define SQUARE(i) ((i)*(i))
inline static void zeroClearInt(int* p, size_t count) { memset(p, 0, sizeof(int) * count); }

@implementation NSImage (StackBlur)

+ (NSImage *)circleImageWithColor:(NSColor *)color size:(NSSize)size text:(NSString *)text font:(NSFont *)font {
    NSImage *colorImage = [self imageWithColor:color size:size text:text font:font];
    if ([text isEqualToString:@"所有人"]) {
        colorImage = [NSImage imageNamed:@"all_icon"];
    }
    return [colorImage circleImageWithBorderWidth:0 borderColor:[NSColor whiteColor] size:size];
}

+ (NSImage *)circleImageWithColor:(NSColor *)color size:(NSSize)size {
    return  [self circleImageWithColor:color size:size text:nil];
}

+ (NSImage *)circleImageWithColor:(NSColor *)color size:(NSSize)size text:(NSString *)text {
    NSImage *colorImage = [self imageWithColor:color size:size text:text font:nil];
    return [colorImage circleImageWithBorderWidth:0 borderColor:[NSColor whiteColor] size:size];
}


+ (NSImage *)imageWithColor:(NSColor *)color size:(NSSize)size {
    return [self imageWithColor:color size:size text:nil font:nil];
}

+ (NSImage *)imageWithColor:(NSColor *)color size:(NSSize)size text:(NSString *)text font:(NSFont *)font {
    NSImage *image = [[NSImage alloc] initWithSize:size];
    [image lockFocus];
    [color drawSwatchInRect:NSMakeRect(0, 0, size.width, size.height)];
    if (text.length) {
        font == nil ? font = [NSFont systemFontOfSize:13] :font;
        NSMutableParagraphStyle *pStyle = [[NSMutableParagraphStyle alloc] init];
        [pStyle setAlignment:NSCenterTextAlignment];
        if (text.length>2) {
            text = [text substringWithRange:NSMakeRange(text.length - 2,2)];
        }
        NSAttributedString *attStr = [[NSAttributedString alloc] initWithString:text
                                                                     attributes:
                                      @{
                                        NSForegroundColorAttributeName:[NSColor whiteColor],
                                        NSParagraphStyleAttributeName:pStyle,
                                        NSFontAttributeName:font
                                        }];
        [attStr drawInRect:CGRectMake(0, (18 - size.height) * 0.5, size.width, size.height)];
    }
    
    [image unlockFocus];
    return image;
}









- (NSImage *)circleImageWithBorderWidth:(CGFloat)borderWidth borderColor:(NSColor *)borderColor size:(CGSize)size
{
    // 1.加载原图
    
    // 2.开启上下文
    CGFloat imageW = size.width + borderWidth;
    CGFloat imageH = size.height + borderWidth;
    
    // 3.取得当前的上下文
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef ctx = CGBitmapContextCreate(NULL,
                                             imageW,
                                             imageH,
                                             8, (4 * imageW),
                                             genericColorSpace,
                                             (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGColorSpaceRelease(genericColorSpace);
    
    
     // 4.画边框(大圆)
    CGContextSetFillColorWithColor(ctx, borderColor.CGColor);

    CGFloat bigRadius = imageW * 0.5; // 大圆半径
    CGFloat centerX = bigRadius; // 圆心
    CGFloat centerY = bigRadius;
    CGContextAddArc(ctx, centerX, centerY, bigRadius, 0, M_PI * 2, 0);
    CGContextFillPath(ctx); // 画圆
    
    
    // 5.小圆
    CGFloat smallRadius = bigRadius - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadius, 0, M_PI * 2, 0);
    
    // 裁剪(后面画的东西才会受裁剪的影响)
    CGContextClip(ctx);
    
    // 6.画图
    [self drawInRect:CGRectMake(borderWidth, borderWidth, imageW, imageH)];
    
    // 7.取图
    CGRect destRect = CGRectMake(0, 0, imageW, imageW);
    
    CGContextSetInterpolationQuality(ctx, kCGInterpolationDefault);
    CGContextDrawImage(ctx, destRect, self.CGImage);
    
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(ctx);
    NSImage *result = [NSImage imageWithCGImage:tmpThumbImage];
    
    CGContextRelease(ctx);
    CGImageRelease(tmpThumbImage);
    
    return result;
}







- (NSImage *)stackBlur:(int)inradius
{
    @try
    {
        if (inradius < 1)
        {
            return self;
        }
        // Suggestion xidew to prevent crash if size is null
        if (CGSizeEqualToSize(self.size, CGSizeZero))
        {
            return self;
        }
        
        //	return [other applyBlendFilter:filterOverlay  other:self context:nil];
        // First get the image into your data buffer
        CGImageRef inImage = self.CGImage;
        UInt8 nbPerCompt = CGImageGetBitsPerPixel(inImage);
        CGImageAlphaInfo alphaInfo = CGImageGetAlphaInfo(inImage);
        if(nbPerCompt != 32 || alphaInfo != kCGImageAlphaPremultipliedLast)
        {
            NSImage *tmpImage = [self normalize];
            inImage = tmpImage.CGImage;
        }
        CFDataRef dataRef = CGDataProviderCopyData(CGImageGetDataProvider(inImage));
        CFMutableDataRef m_DataRef = CFDataCreateMutableCopy(0, 0, dataRef);
        CFRelease(dataRef);
        UInt8 * m_PixelBuf=malloc(CFDataGetLength(m_DataRef));
        CFDataGetBytes(m_DataRef,
                       CFRangeMake(0,CFDataGetLength(m_DataRef)) ,
                       m_PixelBuf);
        
        CGContextRef ctx = CGBitmapContextCreate(m_PixelBuf,
                                                 CGImageGetWidth(inImage),
                                                 CGImageGetHeight(inImage),
                                                 CGImageGetBitsPerComponent(inImage),
                                                 CGImageGetBytesPerRow(inImage),
                                                 CGImageGetColorSpace(inImage),
                                                 CGImageGetBitmapInfo(inImage)
                                                 );
        
        // Apply stack blur
        [self.class applyStackBlurToBuffer:m_PixelBuf
                                     width:self.size.width
                                    height:self.size.height
                                withRadius:inradius];
        
        // Make new image
        CGImageRef imageRef = CGBitmapContextCreateImage(ctx);
        CGContextRelease(ctx);
        
        NSImage *finalImage = [NSImage imageWithCGImage:imageRef];
        CGImageRelease(imageRef);
        CFRelease(m_DataRef);
        free(m_PixelBuf);
        return finalImage;
    }
    @catch (NSException *exception)
    {
        return nil;
    }
}


+ (void) applyStackBlurToBuffer:(UInt8*)targetBuffer width:(const int)w height:(const int)h withRadius:(int)inradius
{
    // Constants
    const int radius = inradius; // Transform unsigned into signed for further operations
    const int wm = w - 1;
    const int hm = h - 1;
    const int wh = w*h;
    const int div = radius + radius + 1;
    const int r1 = radius + 1;
    const int divsum = SQUARE((div+1)>>1);
    
    // Small buffers
    int stack[div*3];
    zeroClearInt(stack, div*3);
    
    int vmin[MAX(w,h)];
    zeroClearInt(vmin, MAX(w,h));
    
    // Large buffers
    int *r = malloc(wh*sizeof(int));
    int *g = malloc(wh*sizeof(int));
    int *b = malloc(wh*sizeof(int));
    zeroClearInt(r, wh);
    zeroClearInt(g, wh);
    zeroClearInt(b, wh);
    
    const size_t dvcount = 256 * divsum;
    int *dv = malloc(sizeof(int) * dvcount);
    for (int i = 0;(size_t)i < dvcount;i++) {
        dv[i] = (i / divsum);
    }
    
    // Variables
    int x, y;
    int *sir;
    int routsum,goutsum,boutsum;
    int rinsum,ginsum,binsum;
    int rsum, gsum, bsum, p, yp;
    int stackpointer;
    int stackstart;
    int rbs;
    
    int yw = 0, yi = 0;
    for (y = 0;y < h;y++) {
        rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
        
        for(int i = -radius;i <= radius;i++){
            sir = &stack[(i + radius)*3];
            int offset = (yi + MIN(wm, MAX(i, 0)))*4;
            sir[0] = targetBuffer[offset];
            sir[1] = targetBuffer[offset + 1];
            sir[2] = targetBuffer[offset + 2];
            
            rbs = r1 - abs(i);
            rsum += sir[0] * rbs;
            gsum += sir[1] * rbs;
            bsum += sir[2] * rbs;
            if (i > 0){
                rinsum += sir[0];
                ginsum += sir[1];
                binsum += sir[2];
            } else {
                routsum += sir[0];
                goutsum += sir[1];
                boutsum += sir[2];
            }
        }
        stackpointer = radius;
        
        for (x = 0;x < w;x++) {
            r[yi] = dv[rsum];
            g[yi] = dv[gsum];
            b[yi] = dv[bsum];
            
            rsum -= routsum;
            gsum -= goutsum;
            bsum -= boutsum;
            
            stackstart = stackpointer - radius + div;
            sir = &stack[(stackstart % div)*3];
            
            routsum -= sir[0];
            goutsum -= sir[1];
            boutsum -= sir[2];
            
            if (y == 0){
                vmin[x] = MIN(x + radius + 1, wm);
            }
            
            int offset = (yw + vmin[x])*4;
            sir[0] = targetBuffer[offset];
            sir[1] = targetBuffer[offset + 1];
            sir[2] = targetBuffer[offset + 2];
            rinsum += sir[0];
            ginsum += sir[1];
            binsum += sir[2];
            
            rsum += rinsum;
            gsum += ginsum;
            bsum += binsum;
            
            stackpointer = (stackpointer + 1) % div;
            sir = &stack[(stackpointer % div)*3];
            
            routsum += sir[0];
            goutsum += sir[1];
            boutsum += sir[2];
            
            rinsum -= sir[0];
            ginsum -= sir[1];
            binsum -= sir[2];
            
            yi++;
        }
        yw += w;
    }
    
    for (x = 0;x < w;x++) {
        rinsum = ginsum = binsum = routsum = goutsum = boutsum = rsum = gsum = bsum = 0;
        yp = -radius*w;
        for(int i = -radius;i <= radius;i++) {
            yi = MAX(0, yp) + x;
            
            sir = &stack[(i + radius)*3];
            
            sir[0] = r[yi];
            sir[1] = g[yi];
            sir[2] = b[yi];
            
            rbs = r1 - abs(i);
            
            rsum += r[yi]*rbs;
            gsum += g[yi]*rbs;
            bsum += b[yi]*rbs;
            
            if (i > 0) {
                rinsum += sir[0];
                ginsum += sir[1];
                binsum += sir[2];
            } else {
                routsum += sir[0];
                goutsum += sir[1];
                boutsum += sir[2];
            }
            
            if (i < hm) {
                yp += w;
            }
        }
        yi = x;
        stackpointer = radius;
        for (y = 0;y < h;y++) {
            int offset = yi*4;
            targetBuffer[offset]     = dv[rsum];
            targetBuffer[offset + 1] = dv[gsum];
            targetBuffer[offset + 2] = dv[bsum];
            rsum -= routsum;
            gsum -= goutsum;
            bsum -= boutsum;
            
            stackstart = stackpointer - radius + div;
            sir = &stack[(stackstart % div)*3];
            
            routsum -= sir[0];
            goutsum -= sir[1];
            boutsum -= sir[2];
            
            if (x == 0){
                vmin[y] = MIN(y + r1, hm)*w;
            }
            p = x + vmin[y];
            
            sir[0] = r[p];
            sir[1] = g[p];
            sir[2] = b[p];
            
            rinsum += sir[0];
            ginsum += sir[1];
            binsum += sir[2];
            
            rsum += rinsum;
            gsum += ginsum;
            bsum += binsum;
            
            stackpointer = (stackpointer + 1) % div;
            sir = &stack[stackpointer*3];
            
            routsum += sir[0];
            goutsum += sir[1];
            boutsum += sir[2];
            
            rinsum -= sir[0];
            ginsum -= sir[1];
            binsum -= sir[2];
            
            yi += w;
        }
    }
    
    free(r);
    free(g);
    free(b);
    free(dv);
}


- (NSImage *)normalize
{
    int width = self.size.width;
    int height = self.size.height;
    CGColorSpaceRef genericColorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef thumbBitmapCtxt = CGBitmapContextCreate(NULL,
                                                         width,
                                                         height,
                                                         8, (4 * width),
                                                         genericColorSpace,
                                                         (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    CGColorSpaceRelease(genericColorSpace);
    CGContextSetInterpolationQuality(thumbBitmapCtxt, kCGInterpolationDefault);
    CGRect destRect = CGRectMake(0, 0, width, height);
    CGContextDrawImage(thumbBitmapCtxt, destRect, self.CGImage);
    CGImageRef tmpThumbImage = CGBitmapContextCreateImage(thumbBitmapCtxt);
    CGContextRelease(thumbBitmapCtxt);
    NSImage *result = [NSImage imageWithCGImage:tmpThumbImage];
    CGImageRelease(tmpThumbImage);
    
    return result;
}

- (CGImageRef)CGImage
{
    CGImageRef imageRef = [self CGImageForProposedRect:NULL context:NULL hints:NULL];
    return imageRef;
}

+ (NSImage *)imageWithCGImage:(CGImageRef)imageRef
{
    NSImage *image = [[NSImage alloc] initWithCGImage:imageRef size:NSZeroSize];
    return image;
}

@end
