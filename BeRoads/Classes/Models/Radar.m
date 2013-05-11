//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "Radar.h"


@implementation Radar


@synthesize idRadar;
@synthesize name;
@synthesize lat;
@synthesize lng;
@synthesize date;
@synthesize type;
@synthesize speedLimit;


- (void) dealloc
{
	[idRadar release];
	[name release];
	[lat release];
	[lng release];
	[date release];
	[type release];
	[speedLimit release];
	
	[super dealloc];

}

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
	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSNumber class]])
	{
		self.idRadar = id_;
	}

	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
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

	id date_ = [dic objectForKey:@"date"];
	if([date_ isKindOfClass:[NSString class]])
	{
		self.date = date_;
	}

	id type_ = [dic objectForKey:@"type"];
	if([type_ isKindOfClass:[NSString class]])
	{
		self.type = type_;
	}

	id speedLimit_ = [dic objectForKey:@"speedLimit"];
	if([speedLimit_ isKindOfClass:[NSString class]])
	{
		self.speedLimit = speedLimit_;
	}

	
}

@end
