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

    id time_ = [dic objectForKey:@"time"];
    if([time_ isKindOfClass:[NSDecimalNumber class]]){
        self.time = [time_ intValue];
    }

    id distance_ = [dic objectForKey:@"distance"];
    if([distance_ isKindOfClass:[NSDecimalNumber class]]){
        self.distance = [distance_ intValue];
    }
        
	id category_ = [dic objectForKey:@"category"];
	if([category_ isKindOfClass:[NSString class]])
	{
		self.category = category_;
	}

	id lat_ = [dic objectForKey:@"lat"];
    if([lat_ isKindOfClass:[NSDecimalNumber class]]){
        self.lat = [lat_ doubleValue];
    }
    
    id lng_ = [dic objectForKey:@"lng"];
    if([lat_ isKindOfClass:[NSDecimalNumber class]]){
        self.lng = [lng_ doubleValue];
    }
    
	id idTrafficEvent_ = [dic objectForKey:@"id"];
    if([idTrafficEvent_ isKindOfClass:[NSDecimalNumber class]]){
        self.idTrafficEvent = [idTrafficEvent_ intValue];
    }

	
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
