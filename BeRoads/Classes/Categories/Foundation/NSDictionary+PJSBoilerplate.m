//
//  NSDictionary+PJSBoilerplate.h
//  PJSBoilerplate
//
//  Created by _Rob Feldmann_ on _10/18/13_.
//  Copyright (c) _2013_ _PajamaSoft, LLC_. All rights reserved.
//

#import "NSDictionary+PJSBoilerplate.h"

@implementation NSDictionary (PJSBoilerplate)

- (id)pjs_objectForKeyNotNull:(id)key {
    id object = [self objectForKey:key];
    return object == [NSNull null] ? nil : object;
}

@end
