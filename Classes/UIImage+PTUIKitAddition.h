//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

@import UIKit;

@interface UIImage (ImageEffects)

- (instancetype)applyLightEffect;

- (instancetype)applyExtraLightEffect;

- (instancetype)applyDarkEffect;

- (instancetype)applyMediumLightEffect;

- (instancetype)applyTintEffectWithColor:(UIColor *)tintColor;

- (instancetype)applyBlurWithRadius:(CGFloat)blurRadius
                          tintColor:(UIColor *)tintColor
              saturationDeltaFactor:(CGFloat)saturationDeltaFactor
                          maskImage:(UIImage *)maskImage;

@end

/***
* Fork of Trevor Harmon's UIImage Category
* see: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
*/
@interface UIImage (Alpha)
- (BOOL)hasAlpha;

- (instancetype)imageWithAlpha;

- (instancetype)transparentBorderImage:(NSUInteger)borderSize;

- (CGImageRef)newBorderMask:(NSUInteger)borderSize
                       size:(CGSize)size;
@end


/***
* Fork of Trevor Harmon's UIImage Category
* see: http://vocaro.com/trevor/blog/2009/10/12/resize-a-uiimage-the-right-way/
*/
@interface UIImage (RoundedCorner)
- (instancetype)roundedCornerImage:(NSInteger)cornerSize
                        borderSize:(NSInteger)borderSize;
@end

@interface UIImage (Convenience)
+ (instancetype)screenshot;
@end