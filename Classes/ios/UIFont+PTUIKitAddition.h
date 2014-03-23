//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

@import Foundation;
@import CoreText;

@interface UIFont (CoreFoundationBridge)
+ (instancetype)fontWithCTFontRef:(CTFontRef)ctFont;
@end

CTFontRef CTFontFromUIFont(UIFont *font);
