//
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Camera : NSObject <MKAnnotation>
{
	NSString *city;
	NSString *zone;
	NSString *img;
	double lat;
	double lng;
	int idCamera;
    int distance;
}

@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *zone;
@property (nonatomic, retain) NSString *img;
@property (nonatomic) double lat;
@property (nonatomic) double lng;
@property (nonatomic) int idCamera;
@property (nonatomic) int distance;


- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
