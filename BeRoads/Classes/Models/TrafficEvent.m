//
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

// Import
#import "TrafficEvent.h"


@implementation TrafficEvent


@synthesize message;
@synthesize location;
@synthesize source;
@synthesize time;
@synthesize category;
@synthesize lat;
@synthesize lng;
@synthesize distance;
@synthesize idTrafficEvent;


- (id) initWithJSONDictionary:(NSDictionary *)dic
{
	if(self = [super init])
	{
		[self parseJSONDictionary:dic];
	}
	
	return self;
}

- (void) parseJSONDictionary:(NSDictionary *)dic
{
	// PARSER
	id message_ = [dic objectForKey:@"message"];
	if([message_ isKindOfClass:[NSString class]])
	{
		self.message = message_;
	}

	id location_ = [dic objectForKey:@"location"];
	if([location_ isKindOfClass:[NSString class]])
	{
		self.location = location_;
	}

	id source_ = [dic objectForKey:@"source"];
	if([source_ isKindOfClass:[NSString class]])
	{
		self.source = source_;
	}

	self.time = [[dic objectForKey:@"time"] intValue];
    
    self.distance = [[dic objectForKey:@"distance"] intValue];
    
	id category_ = [dic objectForKey:@"category"];
	if([category_ isKindOfClass:[NSString class]])
	{
		self.category = category_;
	}

	self.lat = [[dic objectForKey:@"lat"] doubleValue];
	
    self.lng = [[dic objectForKey:@"lng"] doubleValue];
	
	self.idTrafficEvent = [[dic objectForKey:@"id"] intValue];

	
}

-(CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.lat, self.lng);
}

- (NSString *)title{
    return category;
}

- (NSString *)subtitle{
    return location;
}

@end
