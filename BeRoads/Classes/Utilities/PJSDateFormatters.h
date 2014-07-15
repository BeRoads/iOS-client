//
//  PJSDateFormatters.h
//  PJSBoilerplate
//
//  Created by Rob Feldmann on 8/13/13.
//  Copyright (c) 2013 PajamaSoft, LLC. All rights reserved.
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
//

#import <Foundation/Foundation.h>

@interface PJSDateFormatters : NSObject

/**
 *  This class is a singleton factory method for NSDateFormatter that
 *  maintains a cache of the 15 most recently vended date formatters.
 *  Creating a dateFormatter is relatively expensive so reusing old
 *  formatters is good programming practice.
 *
 *  This pattern is desireable because you don't have to give
 *  names to your formatter objects. All pairings of format and
 *  locale are remembered for easy vending later.
 *
 *  @return A singleton instance of the PJSDateFormatters class.
 */
+ (instancetype)sharedFormatters;

#pragma mark - Factory Metods

- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle
                                      timeStyle:(NSDateFormatterStyle)timeStyle;


- (NSDateFormatter *)dateFormatterWithDateStyle:(NSDateFormatterStyle)dateStyle
                                      timeStyle:(NSDateFormatterStyle)timeStyle
                                      andLocale:(NSLocale *)locale;

/**
 *  Create an NSDateFormatter with a format and NSLocale
 *
 *  @param format The date format string used by the formatter. See Apple's 
 *                'Data Formatting Guide' for a list of the conversion 
 *                specifiers permitted in date format strings.
 *  @param locale The locale may be nil if no locale information is available 
 *                for the item.
 *
 *  @return Returns a freshly instantiated date formatter the first time a
 *          formatter with the specified format is needed, or an existing formatter
 *          if it's already present.
 */
- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocale:(NSLocale *)locale;

/**
 *  Create an NSDateFormatter with a format and locale identifier
 *
 *  @param format The date format string used by the formatter. See Apple's
 *                'Data Formatting Guide' for a list of the conversion
 *                specifiers permitted in date format strings.
 *  @param localeIdentifier The identifier for the new locale.
 *
 *  @return Returns a freshly instantiated date formatter the first time a
 *          formatter with the specified format is needed, or an existing formatter
 *          if it's already present.
 */
- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format andLocaleIdentifier:(NSString *)localeIdentifier;

/**
 *  Create an NSDateFormatter with a format and locale identifier
 *
 *  @param format The date format string used by the formatter. See Apple's
 *                'Data Formatting Guide' for a list of the conversion
 *                specifiers permitted in date format strings.
 *
 *  @return Returns a freshly instantiated date formatter the first time a
 *          formatter with the specified format is needed, or an existing formatter
 *          if it's already present.
 */
- (NSDateFormatter *)dateFormatterWithFormat:(NSString *)format;

#pragma mark - Helper Methods

+ (NSString *)suffixForDayInDate:(NSDate *)date;

@end
