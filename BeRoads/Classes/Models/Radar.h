//
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Radar : NSObject <MKAnnotation>
{
	NSInteger idRadar;
	NSString *name;
    NSString *address;
	double lat;
	double lng;
	NSString *date;
	NSString *type;
	NSInteger speedLimit;
    NSInteger distance;
}

@property (nonatomic, assign) NSInteger idRadar;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *type;
@property (nonatomic, assign) NSInteger speedLimit;
@property (nonatomic, assign) NSInteger distance;


- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
