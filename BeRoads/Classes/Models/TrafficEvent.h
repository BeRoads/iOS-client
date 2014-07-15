//
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface TrafficEvent : NSObject <MKAnnotation>
{
    NSInteger idTrafficEvent;
    NSString *message;
	NSString *location;
	NSString *source;
	NSDate *time;
	NSString *category;
	double lat;
	double lng;
    NSInteger distance;
}

@property (nonatomic, assign) NSInteger idTrafficEvent;
@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *source;
@property (nonatomic, strong) NSDate *time;
@property (nonatomic, retain) NSString *category;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) NSInteger distance;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
