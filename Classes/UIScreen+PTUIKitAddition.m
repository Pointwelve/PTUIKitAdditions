//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import "UIScreen+PTUIKitAddition.h"


@implementation UIScreen (PTUIKitAddition)

- (BOOL)isRetina
{
   static dispatch_once_t predicate;
   static BOOL answer;

   dispatch_once(&predicate, ^{
      answer = ([self respondsToSelector:@selector(scale)] && [self scale] == 2.0f);
   });
   return answer;
}


- (BOOL)isTall
{
   UIScreen *screen = [UIScreen mainScreen];
   return screen.bounds.size.height == 568.0;

}

@end