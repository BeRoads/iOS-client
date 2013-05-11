//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Radar : NSObject
{
	NSDecimalNumber *idRadar;
	NSString *name;
	NSString *lat;
	NSString *lng;
	NSString *date;
	NSString *type;
	NSString *speedLimit;
}

@property (nonatomic, retain) NSDecimalNumber *idRadar;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lng;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, retain) NSString *speedLimit;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
