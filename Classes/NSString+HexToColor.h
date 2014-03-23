//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HexToColor)

/**
 *  Usage: [hexString toColor];
 *
 *  hexString can be one of the following formats:
 *  1. #RGB
 *  2. #ARGB
 *  3. #RRGGBB
 *  4. #AARRGGBB
 *
 *  Example:
 *  UIColor *redColor = [@"ff0000" toColor];
 *  @return UIColor instance from the hex string
 */
- (UIColor *)toColor;
@end