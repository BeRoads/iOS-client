//
//  UIView+PJSBoilerplate.h
//  PJSBoilerplate
//
//  Created by _Rob Feldmann_ on _7/21/13_.
//  Copyright (c) _2013_ _PajamaSoft, LLC_. All rights reserved.
//
//  Inspiration: Ryan Nystrom https://github.com/rnystrom/RNBoilerplate

#import "UIView+PJSBoilerplate.h"

@implementation UIView (PJSBoilerplate)

#pragma mark - UIView Sizes

- (CGFloat)pjs_left {
    return CGRectGetMinX(self.frame);
}

- (void)setPjs_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)pjs_top {
    return CGRectGetMinY(self.frame);
}

- (void)setPjs_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)pjs_right {
    return CGRectGetMaxX(self.frame);
}

- (void)setPjs_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)pjs_bottom {
    return CGRectGetMaxY(self.frame);
}

- (void)setPjs_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)pjs_width {
    return CGRectGetWidth(self.frame);
}

- (void)setPjs_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)pjs_height {
    return CGRectGetHeight(self.frame);
}

- (void)setPjs_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGPoint)pjs_origin {
    return self.frame.origin;
}

- (void)setPjs_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)pjs_size {
    return self.frame.size;
}

- (void)setPjs_size:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

#pragma mark - Auto Layout Helpers

+ (instancetype)pjs_autolayoutView
{
    UIView *view = [[self alloc] init];
    view.translatesAutoresizingMaskIntoConstraints = NO;
    return view;
}

+ (void)pjs_horizontallyCenterView:(UIView *)view inSuperView:(UIView *)superView {
    NSDictionary *views = NSDictionaryOfVariableBindings(view, superView);
    
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[superView]-(<=1)-[view]"
                                                                      options:NSLayoutFormatAlignAllCenterX
                                                                      metrics:nil
                                                                        views:views]];
}

+ (void)pjs_verticallyCenterView:(UIView *)view inSuperView:(UIView *)superView {
    NSDictionary *views = NSDictionaryOfVariableBindings(view, superView);
    
    [superView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[superView]-(<=1)-[view]"
                                                                      options:NSLayoutFormatAlignAllCenterY
                                                                      metrics:nil
                                                                        views:views]];
}

@end
