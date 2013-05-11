//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface TrafficEvent : NSObject
{
	NSString *message;
	NSString *location;
	NSString *source;
	NSDecimalNumber *time;
	NSString *category;
	NSString *lat;
	NSString *lng;
	NSDecimalNumber *id;
}

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, retain) NSDecimalNumber *time;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lng;
@property (nonatomic, retain) NSDecimalNumber *id;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
