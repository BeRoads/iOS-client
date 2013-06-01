//
//  LSBeRoadsClient.h
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "AFHTTPClient.h"

@interface LSBeRoadsClient : AFHTTPClient

+ (LSBeRoadsClient*)sharedClient;

- (void) getTrafficEvents:(void (^)(NSArray*,NSError*))block location:(CLLocationCoordinate2D)coordinate;

- (void) getRadars:(void (^)(NSArray*,NSError*))block location:(CLLocationCoordinate2D)coordinate;

- (void) getCameras:(void (^)(NSArray*,NSError*))block location:(CLLocationCoordinate2D)coordinate;

@end
