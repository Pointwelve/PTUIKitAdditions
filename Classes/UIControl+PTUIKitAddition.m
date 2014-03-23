//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import "UIControl+PTUIKitAddition.h"
#import <objc/runtime.h>

@interface UIControlEventWrapper : NSObject
@property(nonatomic, assign) UIControlEvents controlEvent;
@property(nonatomic, copy) UIControlEventHandler handler;
@end

@implementation UIControlEventWrapper
@synthesize controlEvent, handler;

- (void)sender:(id)sender
      forEvent:(UIEvent *)event
{
   if (self.handler) {
      self.handler(sender, event);
   }
}

- (void)dealloc
{
   objc_removeAssociatedObjects(self);
}
@end

@implementation UIControl (TargetActionView)

static char *eventWrapperKey;

- (NSMutableArray *)eventWrappers
{
   NSMutableArray *wrappers = objc_getAssociatedObject(self, &eventWrapperKey);
   if (!wrappers) {
      wrappers = [NSMutableArray array];
      objc_setAssociatedObject(self, &eventWrapperKey, wrappers, OBJC_ASSOCIATION_RETAIN);
   }
   return wrappers;
}

- (void)addEventHandler:(UIControlEventHandler)handler
        forControlEvent:(UIControlEvents)controlEvent
{
   UIControlEventWrapper *wrapper = [[UIControlEventWrapper alloc] init];
   wrapper.controlEvent = controlEvent;
   wrapper.handler = handler;

   [self addTarget:wrapper action:@selector(sender:forEvent:)
  forControlEvents:controlEvent];
   [[self eventWrappers] addObject:wrapper];
}

- (void)removeEventHandlersForControlEvent:(UIControlEvents)controlEvent
{
   __block __weak UIControl *weakSelf = self;
   [[self eventWrappers] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
      UIControlEventWrapper *wrapper = obj;
      if (wrapper.controlEvent == controlEvent) {
         [weakSelf removeTarget:wrapper action:NULL forControlEvents:controlEvent];
      }
   }];
}

@end
