//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "Camera.h"


@implementation Camera


@synthesize city;
@synthesize zone;
@synthesize img;
@synthesize lat;
@synthesize lng;
@synthesize id;


- (void) dealloc
{
	[city release];
	[zone release];
	[img release];
	[lat release];
	[lng release];
	[id release];
	
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

	id id_ = [dic objectForKey:@"id"];
	if([id_ isKindOfClass:[NSNumber class]])
	{
		self.id = id_;
	}

	
}

@end
