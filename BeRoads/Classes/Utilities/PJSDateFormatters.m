//
//  PJSDateFormatters.m
//  PJSBoilerplate
//
//  Created by Rob Feldmann on 8/13/13.
//  Copyright (c) 2013 PajamaSoft, LLC. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
//  Inspiration: https://github.com/DougFischer/DFDateFormatterFactory

// TODO
// - Tests

#import "PJSDateFormatters.h"

#define PJSDATEFORMATTERS_CACHE_LIMIT 15

@interface PJSDateFormatters ()

@property (nonatomic, strong) NSCache *existingDataFormatters;

@end

@implementation PJSDateFormatters

- (id)init {
    if ((self = [super init])) {
        _existingDataFormatters = [[NSCache alloc] init];
        _existingDataFormatters.countLimit = PJSDATEFORMATTERS_CACHE_LIMIT;
    }
    return self;
}

+ (PJSDateFormatters *)sharedFormatters {
    static dispatch_once_t once;
    static PJSDateFormatters *_sharedFormatters;
    dispatch_once(&once, ^ { _sharedFormatters = [[PJSDateFormatters alloc] init]; });
    return _sharedFormatters;
}

#pragma mark - Factory Metods

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format
                                   andLocale:(NSLocale *)locale {
    @synchronized(self) {
        NSString *key = [NSString stringWithFormat:@"%@|%@", format, locale.localeIdentifier];
        NSDateFormatter *dateFormatter = [self.existingDataFormatters objectForKey:key];
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = format;
            dateFormatter.locale = locale;
            [self.existingDataFormatters setObject:dateFormatter forKey:key];
        }
        
        return dateFormatter;
    }
}

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle
                                      timeStyle:(NSDateFormatterStyle)timeStyle
                                      andLocale:(NSLocale *)locale {
    @synchronized(self) {
        NSString* dateStyleString = @"";
        switch(dateStyle) {
            case NSDateFormatterNoStyle:
                dateStyleString = @"No";
                break;
                
            case NSDateFormatterLongStyle:
                dateStyleString = @"Long";
                break;
                
            case NSDateFormatterShortStyle:
                dateStyleString = @"Short";
                break;
            
            case NSDateFormatterMediumStyle:
                dateStyleString = @"Medium";
                break;
            
            case NSDateFormatterFullStyle:
                dateStyleString = @"Full";
                break;
        }
        
        NSString* timeStyleString = @"";
        switch(timeStyle) {
            case NSDateFormatterNoStyle:
                timeStyleString = @"No";
                break;
                
            case NSDateFormatterLongStyle:
                timeStyleString = @"Long";
                break;
                
            case NSDateFormatterShortStyle:
                timeStyleString = @"Short";
                break;
                
            case NSDateFormatterMediumStyle:
                timeStyleString = @"Medium";
                break;
                
            case NSDateFormatterFullStyle:
                timeStyleString = @"Full";
                break;
        }
        
        NSString *key = [NSString stringWithFormat:@"%@|%@|%@", dateStyleString, timeStyleString, locale.localeIdentifier];
        NSDateFormatter *dateFormatter = [self.existingDataFormatters objectForKey:key];
        if (dateFormatter == nil) {
            dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateStyle = dateStyle;
            dateFormatter.timeStyle = timeStyle;
            dateFormatter.locale = locale;
            [self.existingDataFormatters setObject:dateFormatter forKey:key];
        }
        
        return dateFormatter;
    }
}

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle
                                      timeStyle:(NSDateFormatterStyle)timeStyle {
    return [self dateFormatterWithDateStyle:dateStyle timeStyle:timeStyle andLocale:[NSLocale autoupdatingCurrentLocale]];
}

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format
                         andLocaleIdentifier:(NSString *)localeIdentifier {
    return [self dateFormatterWithFormat:format
                               andLocale:[[NSLocale alloc] initWithLocaleIdentifier:localeIdentifier]];
}

- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format {
    return [self dateFormatterWithFormat:format
                               andLocale:[NSLocale autoupdatingCurrentLocale]];
}

#pragma mark - Helper Methods

+ (NSString *)suffixForDayInDate:(NSDate *)date {
    NSInteger day = [[[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitDay fromDate:date] day];
    if (day >= 11 && day <= 13) {
        return @"th";
    } else if (day % 10 == 1) {
        return @"st";
    } else if (day % 10 == 2) {
        return @"nd";
    } else if (day % 10 == 3) {
        return @"rd";
    } else {
        return @"th";
    }
}

@end
