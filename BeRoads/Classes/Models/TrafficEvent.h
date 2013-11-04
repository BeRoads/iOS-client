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
	NSString *message;
	NSString *location;
	NSString *source;
	int time;
	NSString *category;
	double lat;
	double lng;
    int distance;
	int idTrafficEvent;
}

@property (nonatomic, retain) NSString *message;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *source;
@property (nonatomic) int time;
@property (nonatomic, retain) NSString *category;
@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (nonatomic) int idTrafficEvent;
@property (nonatomic) int distance;

- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
