//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

#import "UIView+PTUIKitAdditon.h"

@implementation UIView (LoadFromNib)

+ (instancetype)loadInstanceFromNib
{
   return [self loadInstanceFromNibNamed:NSStringFromClass([self class])];
}

+ (instancetype)loadInstanceFromNibNamed:(NSString *)nibName
{
   UIView *result = nil;
   NSArray *elements = [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil];
   for (id anObject in elements) {
      if ([anObject isKindOfClass:[self class]]) {
         result = anObject;
         break;
      }
   }
   return result;
}

@end


@implementation UIView (Convenience)

- (NSArray *)allSubviews
{
   NSMutableArray *subviews = [[NSMutableArray alloc] init];

   for (UIView *view in self.subviews) {
      [subviews addObject:view];
   }

   return subviews;
}

- (NSArray *)allSuperView
{
   NSMutableArray *superviews = [[NSMutableArray alloc] init];

   UIView *view = self;
   UIView *superview = nil;
   while (view) {
      superview = [view superview];
      if (!superview) {
         break;
      }

      [superviews addObject:superview];
      view = superview;
   }

   return superviews;
}

- (void)removeAllSubviews
{
   [[self subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

- (void)removeAllSubviewsExceptSubview:(UIView *)subview
{
   for (UIView *view in [self subviews]) {
      if (view != subview) {
         [view removeFromSuperview];
      }
   }
}

- (instancetype)descendantOrSelfWithClass:(Class)class
{
   if ([self isKindOfClass:class])
      return self;

   for (UIView *child in self.subviews) {
      UIView *it = [child descendantOrSelfWithClass:class];
      if (it)
         return it;
   }

   return nil;
}


- (void)resetAndRemoveFromSuperView
{
   self.layer.shadowOffset = CGSizeMake(3, 3);
   self.layer.transform = CATransform3DMakeRotation(0, 0, 1, 0);
   [self removeFromSuperview];
}

- (CGPoint)trueCenter
{
   UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
   return UIInterfaceOrientationIsLandscape(orientation) ? CGPointMake(self.center.y, self.center.x) : self.center;
}

@end


@implementation UIView (RenderToImage)

static BOOL isSupportedDrawViewHierarchyInRect;

+ (void)load
{
   if ([self instancesRespondToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
      isSupportedDrawViewHierarchyInRect = YES;
   } else {
      isSupportedDrawViewHierarchyInRect = NO;
   }
}

- (UIImage *)renderToImage
{
   return [self renderToImageWithScale:0];
}

- (UIImage *)renderToImageWithScale:(CGFloat)scale
{
   UIImage *image = [self renderToImageWithScale:scale legacy:NO];
   return image;
}

- (UIImage *)renderToImageWithScale:(CGFloat)scale legacy:(BOOL)legacy
{
   // If scale is 0, it'll follows the screen scale for creating the bounds
   UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, scale);

   if (legacy || !isSupportedDrawViewHierarchyInRect) {
      // - [CALayer renderInContext:] also renders subviews
      [self.layer renderInContext:UIGraphicsGetCurrentContext()];
   } else {
      [self drawViewHierarchyInRect:self.bounds
                 afterScreenUpdates:YES];
   }

   // Get the image out of the context
   UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
   UIGraphicsEndImageContext();

   // Return the result
   return image;
}

@end

@implementation UIView (Visibility)

- (void)hide
{
   self.alpha = 0.0f;

}

- (void)unhide
{
   if (self.alpha == 0.0f) {
      self.alpha = 1.0f;
   }
}

#define FADE_DURATION_DEFAULT 0.2f

- (void)fadeIn
{
   [self fadeInWithDuration:FADE_DURATION_DEFAULT];
}

- (void)fadeInWithDuration:(CGFloat)duration
{
   UIView *view = self;
   [UIView animateWithDuration:duration
                         delay:0.0
                       options:UIViewAnimationOptionAllowUserInteraction
                    animations:^{
                       [view unhide];
                    }
                    completion:nil
   ];
}

- (void)fadeOutViewWithDuration:(CGFloat)duration
           removedFromSuperview:(BOOL)removedFromSuperview
{
   UIView *view = self;
   [UIView animateWithDuration:duration
                         delay:0.0
                       options:UIViewAnimationOptionAllowUserInteraction
                    animations:^{
                       [view hide];
                    }
                    completion:^(BOOL finished) {
                       if (removedFromSuperview) {
                          [view removeFromSuperview];
                       }
                    }

   ];
}

- (void)fadeOut
{
   [self fadeOutViewWithDuration:FADE_DURATION_DEFAULT
            removedFromSuperview:NO];
}

- (void)fadeOutViewWithDuration:(CGFloat)duration
{
   [self fadeOutViewWithDuration:duration
            removedFromSuperview:NO];
}

- (void)fadeOutAndRemoveFromSuperview
{
   [self fadeOutViewWithDuration:FADE_DURATION_DEFAULT
            removedFromSuperview:YES];
}

- (void)fadeOutAndRemoveFromSuperviewWithDuration:(CGFloat)duration
{
   [self fadeOutViewWithDuration:duration
            removedFromSuperview:YES];
}


@end
