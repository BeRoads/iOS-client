//
//  PJSUtilityMacros.h
//  PJSBoilerplate
//
//  Created by _Rob Feldmann_ on _8/13/13_.
//  Copyright (c) _2013_ _PajamaSoft, LLC_. All rights reserved.
//

/**
 *  Speeding Up NSCoding with Macros
 *  http://stablekernel.com/blog/speeding-up-nscoding-with-macros/
 */
#define OBJC_STRINGIFY(x) @#x
#define encodeObject(x) [aCoder encodeObject:x forKey:OBJC_STRINGIFY(x)]
#define decodeObject(x) x = [aDecoder decodeObjectForKey:OBJC_STRINGIFY(x)]