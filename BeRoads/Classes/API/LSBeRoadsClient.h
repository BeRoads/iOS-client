//
//  LSBeRoadsClient.h
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <AFHTTPSessionManager.h>

@class Radar;
@class Camera;
@class TrafficEvent;

@interface LSBeRoadsClient : AFHTTPSessionManager

+ (LSBeRoadsClient*)sharedClient;

// Get All
- (void) getTrafficEvents:(void (^)(NSArray*,NSError*))block location:(CLLocationCoordinate2D)coordinate;
- (void) getRadars:(void (^)(NSArray*,NSError*))block location:(CLLocationCoordinate2D)coordinate;
- (void) getCameras:(void (^)(NSArray*,NSError*))block location:(CLLocationCoordinate2D)coordinate;

// GetByID
- (void) getTrafficEventById:(NSString*)trafficId block:(void (^)(TrafficEvent*,NSError*))block;
- (void) getRadarById:(NSString*)radarId block:(void (^)(Radar*,NSError*))block;
- (void) getCameraById:(NSString*)cameraId block:(void (^)(Camera*,NSError*))block;

@end
