//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import "UIViewController+PTUIKitAdditon.h"

@implementation UIViewController (DefaultConstructor)
+ (instancetype)controller
{
   return [[self alloc] initWithNibName:NSStringFromClass([self class]) bundle:nil];
}
@end

@implementation UIViewController (TopViewController)
+ (instancetype)topViewController
{
    return [self topViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

+ (instancetype)topViewController:(UIViewController *)rootViewController
{
    if (rootViewController.presentedViewController == nil) {
        return rootViewController;
    }
    
    if ([rootViewController.presentedViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *) rootViewController.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        return [self topViewController:lastViewController];
    }
    
    UIViewController *presentedViewController = rootViewController.presentedViewController;
    return [self topViewController:presentedViewController];
}



@end

@implementation UIViewController (ErrorDisplay)

- (void)displayErrorWithAlert:(NSError *)error
{
   if (!error) {
      return;
   }

   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                   message:[error localizedDescription]
                                                  delegate:nil
                                         cancelButtonTitle:@"OK"
                                         otherButtonTitles:nil];
   [alert show];
}

@end