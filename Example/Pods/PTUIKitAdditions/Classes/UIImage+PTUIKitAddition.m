//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import "UIImage+PTUIKitAddition.h"

@import Accelerate;

@implementation UIImage (ImageEffects)

- (instancetype)applyLightEffect
{
   UIColor *tintColor = [UIColor colorWithWhite:1.0 alpha:0.3];
   return [self applyBlurWithRadius:30
                          tintColor:tintColor
              saturationDeltaFactor:1.8
                          maskImage:nil];
}


- (instancetype)applyExtraLightEffect
{
   UIColor *tintColor = [UIColor colorWithWhite:0.97 alpha:0.82];
   return [self applyBlurWithRadius:20
                          tintColor:tintColor
              saturationDeltaFactor:1.8
                          maskImage:nil];
}


- (instancetype)applyDarkEffect
{
   UIColor *tintColor = [UIColor colorWithWhite:0.11 alpha:0.73];
   return [self applyBlurWithRadius:20
                          tintColor:tintColor
              saturationDeltaFactor:1.8
                          maskImage:nil];
}

- (instancetype)applyMediumLightEffect
{
   UIColor *tintColor = [UIColor colorWithWhite:0.4 alpha:0.63];
   return [self applyBlurWithRadius:20
                          tintColor:tintColor
              saturationDeltaFactor:1.8
                          maskImage:nil];
}

- (instancetype)applyTintEffectWithColor:(UIColor *)tintColor
{
   const CGFloat EffectColorAlpha = 0.6;
   UIColor *effectColor = tintColor;
   size_t componentCount = CGColorGetNumberOfComponents(tintColor.CGColor);
   if (componentCount == 2) {
      CGFloat b;
      if ([tintColor getWhite:&b alpha:NULL]) {
         effectColor = [UIColor colorWithWhite:b
                                         alpha:EffectColorAlpha];
      }
   }
   else {
      CGFloat r, g, b;
      if ([tintColor getRed:&r green:&g blue:&b alpha:NULL]) {
         effectColor = [UIColor colorWithRed:r
                                       green:g
                                        blue:b
                                       alpha:EffectColorAlpha];
      }
   }
   return [self applyBlurWithRadius:10 tintColor:effectColor saturationDeltaFactor:-1.0 maskImage:nil];
}


- (instancetype)applyBlurWithRadius:(CGFloat)blurRadius tintColor:(UIColor *)tintColor saturationDeltaFactor:(CGFloat)saturationDeltaFactor maskImage:(UIImage *)maskImage
{
   // Check pre-conditions.
   if (self.size.width < 1 || self.size.height < 1) {
      NSLog(@">>> ERROR >>invalid size: (%.2f x %.2f). Both dimensions must be >= 1: %@", self.size.width, self.size.height, self);
      return nil;
   }
   if (!self.CGImage) {
      NSLog(@">>> ERROR >>image must be backed by a CGImage: %@", self);
      return nil;
   }
   if (maskImage && !maskImage.CGImage) {
      NSLog(@">>> ERROR >>maskImage must be backed by a CGImage: %@", maskImage);
      return nil;
   }

   CGRect imageRect = {CGPointZero, self.size};
   UIImage *effectImage = self;

   BOOL hasBlur = blurRadius > __FLT_EPSILON__;
   BOOL hasSaturationChange = fabs(saturationDeltaFactor - 1.) > __FLT_EPSILON__;
   if (hasBlur || hasSaturationChange) {
      UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
      CGContextRef effectInContext = UIGraphicsGetCurrentContext();
      CGContextScaleCTM(effectInContext, 1.0, -1.0);
      CGContextTranslateCTM(effectInContext, 0, -self.size.height);
      CGContextDrawImage(effectInContext, imageRect, self.CGImage);

      vImage_Buffer effectInBuffer;
      effectInBuffer.data = CGBitmapContextGetData(effectInContext);
      effectInBuffer.width = CGBitmapContextGetWidth(effectInContext);
      effectInBuffer.height = CGBitmapContextGetHeight(effectInContext);
      effectInBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectInContext);

      UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
      CGContextRef effectOutContext = UIGraphicsGetCurrentContext();
      vImage_Buffer effectOutBuffer;
      effectOutBuffer.data = CGBitmapContextGetData(effectOutContext);
      effectOutBuffer.width = CGBitmapContextGetWidth(effectOutContext);
      effectOutBuffer.height = CGBitmapContextGetHeight(effectOutContext);
      effectOutBuffer.rowBytes = CGBitmapContextGetBytesPerRow(effectOutContext);

      if (hasBlur) {
         // A description of how to compute the box kernel width from the Gaussian
         // radius (aka standard deviation) appears in the SVG spec:
         // http://www.w3.org/TR/SVG/filters.html#feGaussianBlurElement
         //
         // For larger values of 's' (s >= 2.0), an approximation can be used: Three
         // successive box-blurs build a piece-wise quadratic convolution kernel, which
         // approximates the Gaussian kernel to within roughly 3%.
         //
         // let d = floor(s * 3*sqrt(2*pi)/4 + 0.5)
         //
         // ... if d is odd, use three box-blurs of size 'd', centered on the output pixel.
         //
         CGFloat inputRadius = blurRadius * [[UIScreen mainScreen] scale];
         uint32_t radius = (uint32_t) floor(inputRadius * 3. * sqrt(2 * M_PI) / 4 + 0.5);
         if (radius % 2 != 1) {
            radius += 1; // force radius to be odd so that the three box-blur methodology works.
         }
         vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
         vImageBoxConvolve_ARGB8888(&effectOutBuffer, &effectInBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
         vImageBoxConvolve_ARGB8888(&effectInBuffer, &effectOutBuffer, NULL, 0, 0, radius, radius, 0, kvImageEdgeExtend);
      }
      BOOL effectImageBuffersAreSwapped = NO;
      if (hasSaturationChange) {
         CGFloat s = saturationDeltaFactor;
         CGFloat floatingPointSaturationMatrix[] = {
               0.0722 + 0.9278 * s, 0.0722 - 0.0722 * s, 0.0722 - 0.0722 * s, 0,
               0.7152 - 0.7152 * s, 0.7152 + 0.2848 * s, 0.7152 - 0.7152 * s, 0,
               0.2126 - 0.2126 * s, 0.2126 - 0.2126 * s, 0.2126 + 0.7873 * s, 0,
               0, 0, 0, 1,
         };
         const int32_t divisor = 256;
         NSUInteger matrixSize = sizeof(floatingPointSaturationMatrix) / sizeof(floatingPointSaturationMatrix[0]);
         int16_t saturationMatrix[matrixSize];
         for (NSUInteger i = 0; i < matrixSize; ++i) {
            saturationMatrix[i] = (int16_t) roundf(floatingPointSaturationMatrix[i] * divisor);
         }
         if (hasBlur) {
            vImageMatrixMultiply_ARGB8888(&effectOutBuffer, &effectInBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
            effectImageBuffersAreSwapped = YES;
         }
         else {
            vImageMatrixMultiply_ARGB8888(&effectInBuffer, &effectOutBuffer, saturationMatrix, divisor, NULL, NULL, kvImageNoFlags);
         }
      }
      if (!effectImageBuffersAreSwapped)
         effectImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();

      if (effectImageBuffersAreSwapped)
         effectImage = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
   }

   // Set up output context.
   UIGraphicsBeginImageContextWithOptions(self.size, NO, [[UIScreen mainScreen] scale]);
   CGContextRef outputContext = UIGraphicsGetCurrentContext();
   CGContextScaleCTM(outputContext, 1.0, -1.0);
   CGContextTranslateCTM(outputContext, 0, -self.size.height);

   // Draw base image.
   CGContextDrawImage(outputContext, imageRect, self.CGImage);

   // Draw effect image.
   if (hasBlur) {
      CGContextSaveGState(outputContext);
      if (maskImage) {
         CGContextClipToMask(outputContext, imageRect, maskImage.CGImage);
      }
      CGContextDrawImage(outputContext, imageRect, effectImage.CGImage);
      CGContextRestoreGState(outputContext);
   }

   // Add in color tint.
   if (tintColor) {
      CGContextSaveGState(outputContext);
      CGContextSetFillColorWithColor(outputContext, tintColor.CGColor);
      CGContextFillRect(outputContext, imageRect);
      CGContextRestoreGState(outputContext);
   }

   // Output image is ready.
   UIImage *outputImage = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();

   return outputImage;
}

@end

@implementation UIImage (Alpha)

/**
* Returns true if the image has an alpha layer
*/
- (BOOL)hasAlpha
{
   CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
   return (alpha == kCGImageAlphaFirst ||
         alpha == kCGImageAlphaLast ||
         alpha == kCGImageAlphaPremultipliedFirst ||
         alpha == kCGImageAlphaPremultipliedLast);
}

/**
* Returns a copy of the given image, adding an alpha channel if it doesn't already have one
*/
- (instancetype)imageWithAlpha
{
   if ([self hasAlpha]) {
      return self;
   }

   CGFloat scale = MAX(self.scale, 1.0f);
   CGImageRef imageRef = self.CGImage;
   size_t width = (size_t) (CGImageGetWidth(imageRef) * scale);
   size_t height = (size_t) (CGImageGetHeight(imageRef) * scale);

   // The bitsPerComponent and bitmapInfo values are hard-coded to prevent an "unsupported parameter combination" error
   CGContextRef offscreenContext = CGBitmapContextCreate(NULL,
         width,
         height,
         8,
         0,
         CGImageGetColorSpace(imageRef),
         kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);

   // Draw the image into the context and retrieve the new image, which will now have an alpha layer
   CGContextDrawImage(offscreenContext, CGRectMake(0, 0, width, height), imageRef);
   CGImageRef imageRefWithAlpha = CGBitmapContextCreateImage(offscreenContext);
   UIImage *imageWithAlpha = [UIImage imageWithCGImage:imageRefWithAlpha
                                                 scale:self.scale
                                           orientation:UIImageOrientationUp];

   // Clean up
   CGContextRelease(offscreenContext);
   CGImageRelease(imageRefWithAlpha);

   return imageWithAlpha;
}

/**
* Returns a copy of the image with a transparent border of the given size added around its edges.
* If the image has no alpha layer, one will be added to it.
*/
- (instancetype)transparentBorderImage:(NSUInteger)borderSize
{
   // If the image does not have an alpha layer, add one
   UIImage *image = [self imageWithAlpha];
   CGFloat scale = MAX(self.scale, 1.0f);
   NSUInteger scaledBorderSize = (NSUInteger) (borderSize * scale);
   CGRect newRect = CGRectMake(0, 0, image.size.width * scale + scaledBorderSize * 2, image.size.height * scale + scaledBorderSize * 2);

   // Build a context that's the same dimensions as the new size
   CGContextRef bitmap = CGBitmapContextCreate(NULL,
         (size_t) newRect.size.width,
         (size_t) newRect.size.height,
         CGImageGetBitsPerComponent(self.CGImage),
         0,
         CGImageGetColorSpace(self.CGImage),
         CGImageGetBitmapInfo(self.CGImage));

   // Draw the image in the center of the context, leaving a gap around the edges
   CGRect imageLocation = CGRectMake(scaledBorderSize, scaledBorderSize, image.size.width * scale, image.size.height * scale);
   CGContextDrawImage(bitmap, imageLocation, self.CGImage);
   CGImageRef borderImageRef = CGBitmapContextCreateImage(bitmap);

   // Create a mask to make the border transparent, and combine it with the image
   CGImageRef maskImageRef = [self newBorderMask:scaledBorderSize size:newRect.size];
   CGImageRef transparentBorderImageRef = CGImageCreateWithMask(borderImageRef, maskImageRef);
   UIImage *transparentBorderImage = [UIImage imageWithCGImage:transparentBorderImageRef
                                                         scale:self.scale
                                                   orientation:UIImageOrientationUp];

   // Clean up
   CGContextRelease(bitmap);
   CGImageRelease(borderImageRef);
   CGImageRelease(maskImageRef);
   CGImageRelease(transparentBorderImageRef);

   return transparentBorderImage;
}

#pragma mark -
#pragma mark Private helper methods

/**
* Creates a mask that makes the outer edges transparent and everything else opaque
* The size must include the entire mask (opaque part + transparent border)
* The caller is responsible for releasing the returned reference by calling CGImageRelease
*/
- (CGImageRef)newBorderMask:(NSUInteger)borderSize
                       size:(CGSize)size
{
   CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceGray();

   // Build a context that's the same dimensions as the new size
   CGContextRef maskContext = CGBitmapContextCreate(NULL,
         (size_t) size.width,
         (size_t) size.height,
         8, // 8-bit grayscale
         0,
         colorSpace,
         kCGBitmapByteOrderDefault | kCGImageAlphaNone);

   // Start with a mask that's entirely transparent
   CGContextSetFillColorWithColor(maskContext, [UIColor blackColor].CGColor);
   CGContextFillRect(maskContext, CGRectMake(0, 0, size.width, size.height));

   // Make the inner part (within the border) opaque
   CGContextSetFillColorWithColor(maskContext, [UIColor whiteColor].CGColor);
   CGContextFillRect(maskContext, CGRectMake(borderSize, borderSize, size.width - borderSize * 2, size.height - borderSize * 2));

   // Get an image of the context
   CGImageRef maskImageRef = CGBitmapContextCreateImage(maskContext);

   // Clean up
   CGContextRelease(maskContext);
   CGColorSpaceRelease(colorSpace);

   return maskImageRef;
}

@end

@implementation UIImage (RoundedCorner)

// Creates a copy of this image with rounded corners
// If borderSize is non-zero, a transparent border of the given size will also be added
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (instancetype)roundedCornerImage:(NSInteger)cornerSize borderSize:(NSInteger)borderSize
{
   // If the image does not have an alpha layer, add one
   UIImage *image = [self imageWithAlpha];

   CGFloat scale = MAX(self.scale, 1.0f);
   NSUInteger scaledBorderSize = (NSUInteger) (borderSize * scale);

   // Build a context that's the same dimensions as the new size
   CGContextRef context = CGBitmapContextCreate(NULL,
         (size_t) (image.size.width * scale),
         (size_t) (image.size.height * scale),
         CGImageGetBitsPerComponent(image.CGImage),
         0,
         CGImageGetColorSpace(image.CGImage),
         CGImageGetBitmapInfo(image.CGImage));

   // Create a clipping path with rounded corners

   CGContextBeginPath(context);
   [self addRoundedRectToPath:CGRectMake(scaledBorderSize, scaledBorderSize, image.size.width * scale - borderSize * 2, image.size.height * scale - borderSize * 2)
                      context:context
                    ovalWidth:cornerSize * scale
                   ovalHeight:cornerSize * scale];
   CGContextClosePath(context);
   CGContextClip(context);

   // Draw the image to the context; the clipping path will make anything outside the rounded rect transparent
   CGContextDrawImage(context, CGRectMake(0, 0, image.size.width * scale, image.size.height * scale), image.CGImage);

   // Create a CGImage from the context
   CGImageRef clippedImage = CGBitmapContextCreateImage(context);
   CGContextRelease(context);

   // Create a UIImage from the CGImage
   UIImage *roundedImage = [UIImage imageWithCGImage:clippedImage
                                               scale:self.scale
                                         orientation:UIImageOrientationUp];

   CGImageRelease(clippedImage);

   return roundedImage;
}

#pragma mark -
#pragma mark Private helper methods

// Adds a rectangular path to the given context and rounds its corners by the given extents
// Original author: Björn Sållarp. Used with permission. See: http://blog.sallarp.com/iphone-uiimage-round-corners/
- (void)addRoundedRectToPath:(CGRect)rect
                     context:(CGContextRef)context
                   ovalWidth:(CGFloat)ovalWidth
                  ovalHeight:(CGFloat)ovalHeight
{
   if (ovalWidth == 0 || ovalHeight == 0) {
      CGContextAddRect(context, rect);
      return;
   }
   CGContextSaveGState(context);
   CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
   CGContextScaleCTM(context, ovalWidth, ovalHeight);
   CGFloat fw = CGRectGetWidth(rect) / ovalWidth;
   CGFloat fh = CGRectGetHeight(rect) / ovalHeight;
   CGContextMoveToPoint(context, fw, fh / 2);
   CGContextAddArcToPoint(context, fw, fh, fw / 2, fh, 1);
   CGContextAddArcToPoint(context, 0, fh, 0, fh / 2, 1);
   CGContextAddArcToPoint(context, 0, 0, fw / 2, 0, 1);
   CGContextAddArcToPoint(context, fw, 0, fw, fh / 2, 1);
   CGContextClosePath(context);
   CGContextRestoreGState(context);
}

@end

@implementation UIImage (Convenience)
+ (instancetype)screenshot
{
   CGSize imageSize = [[UIScreen mainScreen] bounds].size;

   if (NULL != UIGraphicsBeginImageContextWithOptions) {
      UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
   } else {
      UIGraphicsBeginImageContext(imageSize);
   }

   CGContextRef context = UIGraphicsGetCurrentContext();

   for (UIWindow *window in [[UIApplication sharedApplication] windows]) {
      if (![window respondsToSelector:@selector(screen)] || [window screen] == [UIScreen mainScreen]) {
         CGContextSaveGState(context);

         CGContextTranslateCTM(context, [window center].x, [window center].y);

         CGContextConcatCTM(context, [window transform]);

         CGContextTranslateCTM(context,
               -[window bounds].size.width * [[window layer] anchorPoint].x,
               -[window bounds].size.height * [[window layer] anchorPoint].y);

         [[window layer] renderInContext:context];

         CGContextRestoreGState(context);
      }
   }

   UIImage *image = UIGraphicsGetImageFromCurrentImageContext();

   UIGraphicsEndImageContext();

   return image;
}
@end