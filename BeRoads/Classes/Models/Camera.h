//
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Camera : NSObject
{
	NSString *city;
	NSString *zone;
	NSString *img;
	NSString *lat;
	NSString *lng;
	NSDecimalNumber *idCamera;
}

@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *zone;
@property (nonatomic, retain) NSString *img;
@property (nonatomic, retain) NSString *lat;
@property (nonatomic, retain) NSString *lng;
@property (nonatomic, retain) NSDecimalNumber *idCamera;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
