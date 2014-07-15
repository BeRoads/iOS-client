//
//  UIView+PJSBoilerplate.h
//  PJSBoilerplate
//
//  Created by _Rob Feldmann_ on _7/21/13_.
//  Copyright (c) _2013_ _PajamaSoft, LLC_. All rights reserved.
//
//  Inspiration: Ryan Nystrom https://github.com/rnystrom/RNBoilerplate

@interface UIView (PJSBoilerplate)

#pragma mark - UIView Sizes

@property (nonatomic) CGFloat pjs_left;
@property (nonatomic) CGFloat pjs_top;
@property (nonatomic) CGFloat pjs_right;
@property (nonatomic) CGFloat pjs_bottom;
@property (nonatomic) CGFloat pjs_width;
@property (nonatomic) CGFloat pjs_height;

@property (nonatomic) CGPoint pjs_origin;
@property (nonatomic) CGSize pjs_size;

#pragma mark - Auto Layout Helpers

// Source: http://carpeaqua.com/autolayout/
+ (instancetype)pjs_autolayoutView;

+ (void)pjs_horizontallyCenterView:(UIView *)view inSuperView:(UIView *)superView;

+ (void)pjs_verticallyCenterView:(UIView *)view inSuperView:(UIView *)superView;

@end
