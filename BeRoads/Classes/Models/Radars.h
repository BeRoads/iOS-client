//
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSArray;

@interface Radars : NSObject
{
	NSArray *item;
}

@property (nonatomic, retain) NSArray *item;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
