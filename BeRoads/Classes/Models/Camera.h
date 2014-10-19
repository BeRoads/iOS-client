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
    NSString* img_thumb;
	double lat;
	double lng;
    NSInteger distance;
}

@property (nonatomic, assign) NSInteger idCamera;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *zone;
@property (nonatomic, strong) NSString *img;
@property (nonatomic, strong) NSString* img_thumb;
@property (nonatomic, assign) double lat;
@property (nonatomic, assign) double lng;
@property (nonatomic, assign) NSInteger distance;


- (id) initWithJSONDictionary:(NSDictionary *)dic;
- (void) parseJSONDictionary:(NSDictionary *)dic;

@end
