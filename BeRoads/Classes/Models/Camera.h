//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Camera : NSObject
{
	NSString *city;
	NSString *zone;
	NSString *img;
	NSString *lat;
	NSString *lng;
	NSDecimalNumber *id;
}

@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *zone;
@property (nonatomic, retain) NSString *img;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lng;
@property (nonatomic, retain) NSDecimalNumber *id;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
