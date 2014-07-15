//
//  NSDate+LSDate.h
//  WaliBus-Lite
//
//  Created by Lionel Schinckus on 2/07/14.
//  Copyright (c) 2014 Lionel Schinckus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (LSDate)

/** Returns a new NSDate object with the time set to the indicated hour,
 * minute, and second.
 * @param hour The hour to use in the new date.
 * @param minute The number of minutes to use in the new date.
 * @param second The number of seconds to use in the new date.
 */
+(NSDate *) dateWithHour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second;

@end
