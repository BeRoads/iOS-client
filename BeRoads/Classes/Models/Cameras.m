//
//  Created by Cocoa JSON Editor
//  http://www.cocoajsoneditor.com
//  Copyright 2013 __MyCompanyName__. All rights reserved.
//

// Import
#import "Cameras.h"
#import "Camera.h"


@implementation Cameras


@synthesize item;


- (void) dealloc
{
	[item release];
	
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
	id item_ = [dic objectForKey:@"item"];
	if([item_ isKindOfClass:[NSArray class]])
	{
		NSMutableArray *array = [NSMutableArray array];
		for(NSDictionary *itemDic in item_)
		{
			Camera *item = [[Camera alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
			[item release];
		}
		self.item = [NSArray arrayWithArray:array];
	}

	
}

@end
