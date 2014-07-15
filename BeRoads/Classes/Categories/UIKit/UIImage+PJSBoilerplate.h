//
//  UIImage+PJSBoilerplate.h
//  PJSBoilerplate
//
//  Created by _Rob Feldmann_ on _7/21/13_.
//  Copyright (c) _2013_ _PajamaSoft, LLC_. All rights reserved.
//
//  Source: Ryan Nystrom https://github.com/rnystrom/RNBoilerplate

#import <UIKit/UIKit.h>


@interface UIImage (PJSBoilerplate)

- (UIImage *)pjs_crop:(CGRect)rect;
- (UIImage *)pjs_resize:(CGSize)size;

@end
