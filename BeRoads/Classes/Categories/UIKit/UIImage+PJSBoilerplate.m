//
//  UIImage+PJSBoilerplate.h
//  PJSBoilerplate
//
//  Created by _Rob Feldmann_ on _7/21/13_.
//  Copyright (c) _2013_ _PajamaSoft, LLC_. All rights reserved.
//
//  Source: Ryan Nystrom https://github.com/rnystrom/RNBoilerplate

#import "UIImage+PJSBoilerplate.h"

@implementation UIImage (PJSBoilerplate)

- (UIImage *)pjs_crop:(CGRect)rect {
    if (self.scale > 1.0f) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

- (UIImage *)pjs_resize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

@end
