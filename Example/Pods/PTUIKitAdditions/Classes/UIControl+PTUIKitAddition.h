//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

typedef void(^UIControlEventHandler)(id sender, UIEvent *event);

@interface UIControl (TargetActionView)

- (void)addEventHandler:(UIControlEventHandler)handler forControlEvent:(UIControlEvents)controlEvent;

- (void)removeEventHandlersForControlEvent:(UIControlEvents)controlEvent;

@end
