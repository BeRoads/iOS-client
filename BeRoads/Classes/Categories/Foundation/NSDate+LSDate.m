//
//  NSDate+LSDate.m
//  WaliBus-Lite
//
//  Created by Lionel Schinckus on 2/07/14.
//  Copyright (c) 2014 Lionel Schinckus. All rights reserved.
//

#import "NSDate+LSDate.h"

@implementation NSDate (LSDate)

/** Returns a new NSDate object with the time set to the indicated hour,
 * minute, and second.
 * @param hour The hour to use in the new date.
 * @param minute The number of minutes to use in the new date.
 * @param second The number of seconds to use in the new date.
 */
+(NSDate *) dateWithHour:(NSInteger)hour
                  minute:(NSInteger)minute
                  second:(NSInteger)second
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components: NSCalendarUnitYear|
                                    NSCalendarUnitMonth|
                                    NSCalendarUnitDay
                                               fromDate:[NSDate date]];
    [components setHour:hour];
    [components setMinute:minute];
    [components setSecond:second];
    NSDate *newDate = [calendar dateFromComponents:components];
    return newDate;
}

@end
