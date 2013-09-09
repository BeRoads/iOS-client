//
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

// Import
#import "Camera.h"


@implementation Camera


@synthesize city;
@synthesize zone;
@synthesize img;
@synthesize lat;
@synthesize lng;
@synthesize idCamera;
@synthesize distance;

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
	id city_ = [dic objectForKey:@"city"];
	if([city_ isKindOfClass:[NSString class]])
	{
		self.city = city_;
	}

	id zone_ = [dic objectForKey:@"zone"];
	if([zone_ isKindOfClass:[NSString class]])
	{
		self.zone = zone_;
	}

	id img_ = [dic objectForKey:@"img"];
	if([img_ isKindOfClass:[NSString class]])
	{
		self.img = img_;
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

	id idCamera_ = [dic objectForKey:@"id"];
	if([idCamera_ isKindOfClass:[NSNumber class]])
	{
		self.idCamera = idCamera_;
	}

	
}

#pragma mark ANNOTATION

-(CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake([self.lat doubleValue], [self.lng doubleValue]);
}

- (NSString *)title{
    return city;
}

- (NSString *)subtitle{
    return zone;
}

@end
