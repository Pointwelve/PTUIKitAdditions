//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import "UIFont+PTUIKitAddition.h"


@implementation UIFont (PTUIKitAddition)
+ (instancetype)fontWithCTFontRef:(CTFontRef)ctFont
{
   CFStringRef fontName = CTFontCopyFullName(ctFont);
   CGFloat fontSize = CTFontGetSize(ctFont);

   UIFont *ret = [UIFont fontWithName:(__bridge_transfer NSString *) fontName size:fontSize];
   return ret;
}

@end

CTFontRef CTFontFromUIFont(UIFont *font) {
   CTFontRef ctFont = CTFontCreateWithName((__bridge CFStringRef) font.fontName,
         font.pointSize,
         NULL);
   return ctFont;
}
