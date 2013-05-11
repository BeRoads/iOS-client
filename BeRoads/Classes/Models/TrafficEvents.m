//
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

// Import
#import "TrafficEvents.h"
#import "TrafficEvent.h"


@implementation TrafficEvents


@synthesize item;

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
			TrafficEvent *item = [[TrafficEvent alloc] initWithJSONDictionary:itemDic];
			[array addObject:item];
		}
		self.item = [NSArray arrayWithArray:array];
	}

	
}

@end
