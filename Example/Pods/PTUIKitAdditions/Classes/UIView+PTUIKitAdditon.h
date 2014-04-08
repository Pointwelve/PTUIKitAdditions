//
// Created by Ryne Cheow on 3/23/14.
// Copyright (c) 2014 Pointwelve Studio. All rights reserved.
//

@import UIKit;

@interface UIView (LoadFromNib)
+ (instancetype)loadInstanceFromNib;

+ (instancetype)loadInstanceFromNibNamed:(NSString *)nibName;
@end

@interface UIView (Convenience)

- (NSArray *)allSubviews;

- (NSArray *)allSuperView;

- (void)removeAllSubviews;

- (void)removeAllSubviewsExceptSubview:(UIView *)subview;

- (instancetype)descendantOrSelfWithClass:(Class)class;

- (CGPoint)trueCenter;
@end

@interface UIView (RenderToImage)

- (UIImage *)renderToImage;

- (UIImage *)renderToImageWithScale:(CGFloat)scale;

- (UIImage *)renderToImageWithScale:(CGFloat)scale legacy:(BOOL)legacy;

@end

@interface UIView (Visibility)

- (void)hide;

- (void)unhide;

- (void)fadeIn;

- (void)fadeInWithDuration:(CGFloat)duration;

- (void)fadeOut;

- (void)fadeOutViewWithDuration:(CGFloat)duration;

- (void)fadeOutAndRemoveFromSuperview;

- (void)fadeOutAndRemoveFromSuperviewWithDuration:(CGFloat)duration;
@end