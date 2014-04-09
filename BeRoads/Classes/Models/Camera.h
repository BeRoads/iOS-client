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
    NSInteger idCamera;
	NSString *city;
	NSString *zone;
	NSString *img;
	double lat;
	double lng;
    NSInteger distance;
}

@property (nonatomic, assign) NSInteger idCamera;
@property (nonatomic, retain) NSString *city;
@property (nonatomic, retain) NSString *zone;
@property (nonatomic, retain) NSString *img;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) NSInteger distance;


- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
