//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import "NSString+HexToColor.h"
#import "UIColor+PTUIKitAddition.h"

@implementation NSString (HexToColor)
- (UIColor *)toColor
{
   return hexColorWithString(self);
}

@end