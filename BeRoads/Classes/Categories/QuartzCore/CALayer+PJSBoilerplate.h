//
//  CALayer+PJSBoilerplate.h
//  PJSBoilerplate
//
//  Created by _Rob Feldmann_ on _7/21/13_.
//  Copyright (c) _2013_ _PajamaSoft, LLC_. All rights reserved.
//
//  Inspiration: Ryan Nystrom https://github.com/rnystrom/RNBoilerplate

#import <QuartzCore/QuartzCore.h>

@interface CALayer (PJSBoilerplate)

@property (nonatomic) CGFloat pjs_left;
@property (nonatomic) CGFloat pjs_top;
@property (nonatomic) CGFloat pjs_right;
@property (nonatomic) CGFloat pjs_bottom;
@property (nonatomic) CGFloat pjs_width;
@property (nonatomic) CGFloat pjs_height;

@property (nonatomic) CGPoint pjs_origin;
@property (nonatomic) CGSize pjs_size;

@end
