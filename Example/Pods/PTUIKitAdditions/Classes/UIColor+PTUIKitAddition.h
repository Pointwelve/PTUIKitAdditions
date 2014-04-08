//
//  UIColor+PTUIKitAddition.h
//  PTUIKitAdditions Sample
//
//  Created by Ryne Cheow on 3/23/14.
//  Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

@import UIKit;

UIColor *RGB(uint r, uint g, uint b);

UIColor *RGBA(uint r, uint g, uint b, CGFloat a);

UIColor *hexColor(uint hexValue);

UIColor *hexColorWithAlpha(uint hexvalue, CGFloat alpha);

UIColor *hexColorWithString(NSString *hexString);

UIColor *HSB(uint hueDegree, CGFloat saturation, CGFloat brightness, CGFloat alpha);

@interface UIColor (Convenience)

- (instancetype)lightenColorByValue:(float)value;

- (instancetype)darkenColorByValue:(float)value;

- (BOOL)isLightColor;

@end
