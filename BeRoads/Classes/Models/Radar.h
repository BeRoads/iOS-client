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
	int idRadar;
	NSString *name;
    NSString *address;
	double lat;
	double lng;
	NSString *date;
	NSString *type;
	int speedLimit;
    int distance;
}

@property (nonatomic) int idRadar;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *address;
@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *type;
@property (nonatomic) int speedLimit;
@property (nonatomic) int distance;


- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
