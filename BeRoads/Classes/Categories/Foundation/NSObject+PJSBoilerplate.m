//
//  NSObject+PJSBoilerplate.m
//  PJSBoilerplate
//
//  Created by Rob Feldmann on 12/22/13.
//  Copyright (c) 2013 Your Company Name. All rights reserved.
//

#import "NSObject+PJSBoilerplate.h"


BOOL PJSIsEmpty(id obj) {
    
    if (obj == nil || (id)obj == [NSNull null]) {
        return YES;
    }
    
    if ([obj respondsToSelector:@selector(count)]) {
        return [obj count] < 1;
    }
    
    if ([obj respondsToSelector:@selector(length)]) {
        return [obj length] < 1;
    }
    
    return NO; /*Shouldn't get here very often.*/
}


@implementation NSObject (PJSBoilerplate)

@end
