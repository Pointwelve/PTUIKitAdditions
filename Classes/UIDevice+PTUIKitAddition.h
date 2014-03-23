//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

@import UIKit;

@interface UIDevice (Hardware)
- (BOOL)isSimulator;

- (BOOL)isLegacy;
@end


@interface UIDevice (SystemVersion)

+ (CGFloat)iosVersion;

@end
