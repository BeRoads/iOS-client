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

	id time_ = [dic objectForKey:@"time"];
	if([time_ isKindOfClass:[NSNumber class]])
	{
		self.time = time_;
	}

	id category_ = [dic objectForKey:@"category"];
	if([category_ isKindOfClass:[NSString class]])
	{
		self.category = category_;
	}

	id lat_ = [dic objectForKey:@"lat"];
	if([lat_ isKindOfClass:[NSString class]])
	{
		self.lat = lat_;
	}

	id lng_ = [dic objectForKey:@"lng"];
	if([lng_ isKindOfClass:[NSString class]])
	{
		self.lng = lng_;
	}

	id idTrafficEvent_ = [dic objectForKey:@"id"];
	if([idTrafficEvent_ isKindOfClass:[NSNumber class]])
	{
		self.idTrafficEvent = idTrafficEvent_;
	}

	
}

-(CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake([self.lat doubleValue], [self.lng doubleValue]);
}

- (NSString *)title{
    return category;
}

- (NSString *)subtitle{
    return location;
}

@end
