//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import "UIDevice+PTUIKitAddition.h"


@implementation UIDevice (Hardware)

- (BOOL)isSimulator
{
   static NSString *simulatorModel = @"iPhone Simulator";
   return [[self model] isEqualToString:simulatorModel];
}


- (BOOL)isLegacy
{
   static NSString *iPodTouchModel = @"iPod touch";
   static NSString *iPhoneModel = @"iPhone";
   static NSString *iPhone3GModel = @"iPhone 3G";
   static NSString *iPhone3GSModel = @"iPhone 3GS";

   NSString *model = [self model];

   return ([model isEqualToString:iPodTouchModel] || [model isEqualToString:iPhoneModel] ||
         [model isEqualToString:iPhone3GModel] || [model isEqualToString:iPhone3GSModel]);
}


@end

@implementation UIDevice (SystemVersion)

+ (CGFloat)iosVersion
{
   return [[[UIDevice currentDevice] systemVersion] floatValue];
}
@end

