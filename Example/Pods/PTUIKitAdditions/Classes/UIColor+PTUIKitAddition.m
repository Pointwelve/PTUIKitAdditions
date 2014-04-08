//
//  UIColor+PTUIKitAddition.m
//  PTUIKitAdditions Sample
//
//  Created by Ryne Cheow on 3/23/14.
//  Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import "UIColor+PTUIKitAddition.h"

UIColor *RGB(uint r, uint g, uint b) {
   return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:1];
};

UIColor *RGBA(uint r, uint g, uint b, CGFloat a) {
   return [UIColor colorWithRed:r / 255.0 green:g / 255.0 blue:b / 255.0 alpha:a];
};

UIColor *hexColor(uint hexValue) {
   return hexColorWithAlpha(hexValue, 1.0f);
}

UIColor *hexColorWithAlpha(uint hexValue, CGFloat alpha) {
   return [UIColor
         colorWithRed:((float) ((hexValue & 0xFF0000) >> 16)) / 255.0
                green:((float) ((hexValue & 0xFF00) >> 8)) / 255.0
                 blue:((float) (hexValue & 0xFF)) / 255.0
                alpha:alpha];
}


UIColor *HSB(uint hueDegree, CGFloat saturation, CGFloat brightness, CGFloat alpha) {
   return [UIColor colorWithHue:hueDegree / 360.0f saturation:saturation
                     brightness:brightness alpha:alpha];
}

@implementation UIColor (Private)
/**
* By Micah Hainline  http://stackoverflow.com/users/590840/micah-hainline
*/
+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length
{
   NSString *substring = [string substringWithRange:NSMakeRange(start, length)];
   NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat:@"%@%@", substring, substring];
   unsigned hexComponent;
   [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
   return hexComponent / 255.0;
}
@end

/**
* By Micah Hainline  http://stackoverflow.com/users/590840/micah-hainline
*/
UIColor *hexColorWithString(NSString *hexString) {
   NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
   CGFloat alpha, red, blue, green;
   switch ([colorString length]) {
      case 3: // #RGB
         alpha = 1.0f;
         red = [UIColor colorComponentFrom:colorString start:0 length:1];
         green = [UIColor colorComponentFrom:colorString start:1 length:1];
         blue = [UIColor colorComponentFrom:colorString start:2 length:1];
         break;
      case 4: // #ARGB
         alpha = [UIColor colorComponentFrom:colorString start:0 length:1];
         red = [UIColor colorComponentFrom:colorString start:1 length:1];
         green = [UIColor colorComponentFrom:colorString start:2 length:1];
         blue = [UIColor colorComponentFrom:colorString start:3 length:1];
         break;
      case 6: // #RRGGBB
         alpha = 1.0f;
         red = [UIColor colorComponentFrom:colorString start:0 length:2];
         green = [UIColor colorComponentFrom:colorString start:2 length:2];
         blue = [UIColor colorComponentFrom:colorString start:4 length:2];
         break;
      case 8: // #AARRGGBB
         alpha = [UIColor colorComponentFrom:colorString start:0 length:2];
         red = [UIColor colorComponentFrom:colorString start:2 length:2];
         green = [UIColor colorComponentFrom:colorString start:4 length:2];
         blue = [UIColor colorComponentFrom:colorString start:6 length:2];
         break;
      default:
         [NSException raise:@"Invalid color value" format:@"Color value %@ is invalid.  It should be a hex value of the form #RBG, #ARGB, #RRGGBB, or #AARRGGBB", hexString];
         break;
   }
   return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}


@implementation UIColor (Convenience)

- (instancetype)lightenColorByValue:(float)value
{
   size_t totalComponents = CGColorGetNumberOfComponents(self.CGColor);
   bool isGreyscale = totalComponents == 2 ? YES : NO;

   CGFloat *oldComponents = (CGFloat *) CGColorGetComponents(self.CGColor);
   CGFloat newComponents[4];

   if (isGreyscale) {
      newComponents[0] = oldComponents[0] + value > 1.0 ? 1.0 : oldComponents[0] + value;
      newComponents[1] = oldComponents[0] + value > 1.0 ? 1.0 : oldComponents[0] + value;
      newComponents[2] = oldComponents[0] + value > 1.0 ? 1.0 : oldComponents[0] + value;
      newComponents[3] = oldComponents[1];
   }
   else {
      newComponents[0] = oldComponents[0] + value > 1.0 ? 1.0 : oldComponents[0] + value;
      newComponents[1] = oldComponents[1] + value > 1.0 ? 1.0 : oldComponents[1] + value;
      newComponents[2] = oldComponents[2] + value > 1.0 ? 1.0 : oldComponents[2] + value;
      newComponents[3] = oldComponents[3];
   }

   CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
   CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
   CGColorSpaceRelease(colorSpace);

   UIColor *retColor = [UIColor colorWithCGColor:newColor];
   CGColorRelease(newColor);

   return retColor;
}


- (instancetype)darkenColorByValue:(float)value
{
   size_t totalComponents = CGColorGetNumberOfComponents(self.CGColor);
   bool isGreyscale = totalComponents == 2 ? YES : NO;

   CGFloat *oldComponents = (CGFloat *) CGColorGetComponents(self.CGColor);
   CGFloat newComponents[4];

   if (isGreyscale) {
      newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value;
      newComponents[1] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value;
      newComponents[2] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value;
      newComponents[3] = oldComponents[1];
   }
   else {
      newComponents[0] = oldComponents[0] - value < 0.0 ? 0.0 : oldComponents[0] - value;
      newComponents[1] = oldComponents[1] - value < 0.0 ? 0.0 : oldComponents[1] - value;
      newComponents[2] = oldComponents[2] - value < 0.0 ? 0.0 : oldComponents[2] - value;
      newComponents[3] = oldComponents[3];
   }

   CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
   CGColorRef newColor = CGColorCreate(colorSpace, newComponents);
   CGColorSpaceRelease(colorSpace);

   UIColor *retColor = [UIColor colorWithCGColor:newColor];
   CGColorRelease(newColor);

   return retColor;
}


- (BOOL)isLightColor
{
   size_t totalComponents = CGColorGetNumberOfComponents(self.CGColor);
   bool isGreyscale = totalComponents == 2 ? YES : NO;

   CGFloat *components = (CGFloat *) CGColorGetComponents(self.CGColor);
   CGFloat sum;

   if (isGreyscale) {
      sum = components[0];
   }
   else {
      sum = (components[0] + components[1] + components[2]) / 3.0;
   }

   return (sum > 0.8);
}


@end

@implementation UIColor (CrossFade)

+ (instancetype)colorForFadeBetweenFirstColor:(UIColor *)firstColor
                                  secondColor:(UIColor *)secondColor
                                      atRatio:(CGFloat)ratio
{
   return [self colorForFadeBetweenFirstColor:firstColor secondColor:secondColor atRatio:ratio compareColorSpaces:YES];

}

+ (instancetype)colorForFadeBetweenFirstColor:(UIColor *)firstColor secondColor:(UIColor *)secondColor atRatio:(CGFloat)ratio compareColorSpaces:(BOOL)compare
{
   // Eliminate values outside of 0 <--> 1
   ratio = MIN(MAX(0, ratio), 1);

   // Convert to common RGBA colorspace if needed
   if (compare) {
      if (CGColorGetColorSpace(firstColor.CGColor) != CGColorGetColorSpace(secondColor.CGColor)) {
         firstColor = [UIColor colorConvertedToRGBA:firstColor];
         secondColor = [UIColor colorConvertedToRGBA:secondColor];
      }
   }

   // Grab color components
   const CGFloat *firstColorComponents = CGColorGetComponents(firstColor.CGColor);
   const CGFloat *secondColorComponents = CGColorGetComponents(secondColor.CGColor);

   // Interpolate between colors
   CGFloat interpolatedComponents[CGColorGetNumberOfComponents(firstColor.CGColor)];
   for (NSUInteger i = 0; i < CGColorGetNumberOfComponents(firstColor.CGColor); i++) {
      interpolatedComponents[i] = firstColorComponents[i] * (1 - ratio) + secondColorComponents[i] * ratio;
   }

   // Create interpolated color
   CGColorRef interpolatedCGColor = CGColorCreate(CGColorGetColorSpace(firstColor.CGColor), interpolatedComponents);
   UIColor *interpolatedColor = [UIColor colorWithCGColor:interpolatedCGColor];
   CGColorRelease(interpolatedCGColor);

   return interpolatedColor;
}

+ (NSArray *)colorsForFadeBetweenFirstColor:(UIColor *)firstColor
                                  lastColor:(UIColor *)lastColor
                                    inSteps:(NSUInteger)steps
{

   return [self colorsForFadeBetweenFirstColor:firstColor lastColor:lastColor withRatioEquation:nil inSteps:steps];
}

+ (NSArray *)colorsForFadeBetweenFirstColor:(UIColor *)firstColor lastColor:(UIColor *)lastColor withRatioEquation:(float (^)(float input))equation inSteps:(NSUInteger)steps
{
   // Handle degenerate cases
   if (steps == 0)
      return nil;
   if (steps == 1)
      return [NSArray arrayWithObject:firstColor];
   if (steps == 2)
      return [NSArray arrayWithObjects:firstColor, lastColor, nil];

   // Assume linear if no equation is passed
   if (equation == nil) {
      equation = ^(float input) {
         return input;
      };
   }

   // Calculate step size
   CGFloat stepSize = 1.0f / (steps - 1);

   // Array to store colors in steps
   NSMutableArray *colors = [[NSMutableArray alloc] initWithCapacity:steps];
   [colors addObject:firstColor];

   // Compute intermediate colors
   CGFloat ratio = stepSize;
   for (int i = 2; i < steps; i++) {
      [colors addObject:[self colorForFadeBetweenFirstColor:firstColor secondColor:lastColor atRatio:equation(ratio)]];
      ratio += stepSize;
   }

   [colors addObject:lastColor];
   return colors;
}

+ (CAKeyframeAnimation *)keyframeAnimationForKeyPath:(NSString *)keyPath
                                            duration:(NSTimeInterval)duration
                                   betweenFirstColor:(UIColor *)firstColor
                                           lastColor:(UIColor *)lastColor
{
   return [UIColor keyframeAnimationForKeyPath:keyPath
                                      duration:duration
                             betweenFirstColor:firstColor
                                     lastColor:lastColor
                             withRatioEquation:^float(float input) {
                                return input;
                             } inSteps:(NSUInteger) floorf((float) (duration * 30.0f))];
}

+ (CAKeyframeAnimation *)keyframeAnimationForKeyPath:(NSString *)keyPath
                                            duration:(NSTimeInterval)duration
                                   betweenFirstColor:(UIColor *)firstColor
                                           lastColor:(UIColor *)lastColor
                                   withRatioEquation:(float (^)(float input))equation
                                             inSteps:(NSUInteger)steps
{
   CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:keyPath];
   animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
   animation.duration = duration;

   NSArray *colorRefs = [[self colorsForFadeBetweenFirstColor:firstColor lastColor:lastColor withRatioEquation:equation inSteps:steps] valueForKeyPath:@"CCF_CGColor"];

   animation.values = colorRefs;
   return animation;
}

#pragma mark - Helpers

+ (UIColor *)colorConvertedToRGBA:(UIColor *)colorToConvert;
{
   CGFloat red;
   CGFloat green;
   CGFloat blue;
   CGFloat alpha;

   // Convert color to RGBA with a CGContext. UIColor's getRed:green:blue:alpha: doesn't work across color spaces. Adapted from http://stackoverflow.com/a/4700259

   alpha = CGColorGetAlpha(colorToConvert.CGColor);

   CGColorRef opaqueColor = CGColorCreateCopyWithAlpha(colorToConvert.CGColor, 1.0f);
   CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
   unsigned char resultingPixel[CGColorSpaceGetNumberOfComponents(rgbColorSpace)];
   CGContextRef context = CGBitmapContextCreate((void *) &resultingPixel, 1, 1, 8, 4, rgbColorSpace, (CGBitmapInfo) kCGImageAlphaNoneSkipLast);
   CGContextSetFillColorWithColor(context, opaqueColor);
   CGColorRelease(opaqueColor);
   CGContextFillRect(context, CGRectMake(0.f, 0.f, 1.f, 1.f));
   CGContextRelease(context);
   CGColorSpaceRelease(rgbColorSpace);

   red = resultingPixel[0] / 255.0f;
   green = resultingPixel[1] / 255.0f;
   blue = resultingPixel[2] / 255.0f;

   return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

- (id)valueForUndefinedKey:(NSString *)key
{
   if ([key isEqualToString:@"CCF_CGColor"]) {
      return (id) self.CGColor;
   }

   return [super valueForUndefinedKey:key];
}

@end

