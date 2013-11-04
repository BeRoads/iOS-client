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

	self.lat = [[dic objectForKey:@"lat"] doubleValue];

	self.lng = [[dic objectForKey:@"lng"] doubleValue];

	self.idCamera = [[dic objectForKey:@"id"] intValue];
}

-(void)encodeWithCoder:(NSCoder *)encoder
{
    
    [encoder encodeObject:city forKey:@"city"];
    [encoder encodeObject:zone forKey:@"zone"];
    [encoder encodeObject:img forKey:@"img"];
    [encoder encodeDouble:lat forKey:@"lat"];
    [encoder encodeDouble:lng forKey:@"lng"];
    [encoder encodeInteger:idCamera forKey:@"idCamera"];
}

-(id)initWithCoder:(NSCoder *)decoder
{
    self.city = [decoder decodeObjectForKey:@"city"];
    self.zone = [decoder decodeObjectForKey:@"zone"];
    self.img = [decoder decodeObjectForKey:@"img"];
    self.lat = [decoder decodeDoubleForKey:@"lat"];
    self.lng = [decoder decodeDoubleForKey:@"lng"];
    self.idCamera = [decoder decodeIntegerForKey:@"idCamera"];
    return self;
}

#pragma mark ANNOTATION

-(CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.lat, self.lng);
}

- (NSString *)title{
    return city;
}

- (NSString *)subtitle{
    return zone;
}

@end
