//
//  LSBeRoadsClient.m
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSBeRoadsClient.h"

#import <AFNetworking.h>

#import "Camera.h"
#import "TrafficEvent.h"
#import "Radar.h"

@implementation LSBeRoadsClient

static NSString * const kBeRoadsBaseURLString = @"http://data.beroads.com/v2/iway/";
static NSString * const kTrafficEvents = @"TrafficEvent";
static NSString * const kRadar = @"Radar.json";
static NSString * const kCamera = @"Camera.json";

+ (LSBeRoadsClient *)sharedClient {
    static LSBeRoadsClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[LSBeRoadsClient alloc] initWithBaseURL:[NSURL URLWithString:kBeRoadsBaseURLString]];
    });
    
    return _sharedClient;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
    }
    return self;
}

#pragma mark GET ALL

- (void) getTrafficEvents:(void (^)(NSArray*,NSError*))block location:(CLLocationCoordinate2D)coordinate {    
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@",kTrafficEvents,language,@"all.json"];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude] forKey:@"from"];
   
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger area = [userDefaults integerForKey:kAreaPreference];
    
    if (area > 0) {
        [parameters setObject:[NSString stringWithFormat:@"%li",(long)area] forKey:@"area"];
    }
    
	[self GET:path parameters:parameters success:^(NSURLSessionDataTask* task, id JSON){
		// Block success
		dispatch_queue_t jsonParsing = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
		dispatch_async(jsonParsing, ^{
            NSArray* trafficEventsJSON = JSON;
            NSMutableArray* trafficEvents = [NSMutableArray array];
            [trafficEventsJSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [trafficEvents addObject:[[TrafficEvent alloc] initWithJSONDictionary:obj]];
            }];
            
			dispatch_async(dispatch_get_main_queue(), ^{
                
                if(block){
                    block(trafficEvents,nil);
                }
			});
		});
		
		// End of success block
	} failure:^(NSURLSessionDataTask *task, NSError *error){
		NSLog(@"Error : %@",error);
		
		// Si block, callback vers le block
		if(block){
			block(nil,error);
		}
	}];
	
}

- (void) getRadars:(void (^)(NSArray*,NSError*))block location:(CLLocationCoordinate2D)coordinate {
    NSString* path = [NSString stringWithFormat:@"%@",kRadar];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude] forKey:@"from"];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger area = [userDefaults integerForKey:kAreaPreference];
    
    //limit the amount of radars so we don't overcrowd the map when the user
    //is going crazy with distances > 100
    [parameters setObject:[NSString stringWithFormat:@"%i",50] forKey:@"max"];
    
    if (area > 0) {
        [parameters setObject:[NSString stringWithFormat:@"%li",(long)area] forKey:@"area"];
        
    }
    
	[self GET:path parameters:parameters success:^(NSURLSessionDataTask* task, id JSON){
		// Block success
		dispatch_queue_t jsonParsing = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
		dispatch_async(jsonParsing, ^{
            NSArray* radarsJSON = JSON;
            NSMutableArray* radars = [NSMutableArray array];
            [radarsJSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [radars addObject:[[Radar alloc] initWithJSONDictionary:obj]];
            }];
            
			dispatch_async(dispatch_get_main_queue(), ^{
                if(block){
                    block(radars,nil);
                }
			});
		});
		
		// End of success block
	} failure:^(NSURLSessionDataTask *task, NSError *error){
		NSLog(@"Error : %@",error);
		
		// Si block, callback vers le block
		if(block){
			block(nil,error);
		}
	}];
	
}

- (void) getCameras:(void (^)(NSArray*,NSError*))block location:(CLLocationCoordinate2D)coordinate {    
    NSString* path = [NSString stringWithFormat:@"%@",kCamera];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:[NSString stringWithFormat:@"%f,%f",coordinate.latitude,coordinate.longitude] forKey:@"from"];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
    NSInteger area = [userDefaults integerForKey:kAreaPreference];
    
    if (area > 0) {
        [parameters setObject:[NSString stringWithFormat:@"%li",(long)area] forKey:@"area"];
    }
    
	[self GET:path parameters:parameters success:^(NSURLSessionDataTask* task, id JSON){
		// Block success
		dispatch_queue_t jsonParsing = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
		dispatch_async(jsonParsing, ^{
            NSArray* camerasJSON = JSON;
            NSMutableArray* cameras = [NSMutableArray array];
            [camerasJSON enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                [cameras addObject:[[Camera alloc] initWithJSONDictionary:obj]];
            }];
            
			dispatch_async(dispatch_get_main_queue(), ^{
                
                if(block){
                    block(cameras,nil);
                }
			});
		});
		
		// End of success block
	} failure:^(NSURLSessionDataTask *task, NSError *error){
		NSLog(@"Error : %@",error);
		
		// Si block, callback vers le block
		if(block){
			block(nil,error);
		}
	}];
}

#pragma mark - GET by ID

- (void) getTrafficEventById:(NSUInteger)id block:(void (^)(TrafficEvent*,NSError*))block {
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    
    NSString* path = [NSString stringWithFormat:@"%@/%@/%@",kTrafficEvents,language,@"all.json"];
    
    NSDictionary* parameters = @{@"id":[NSString stringWithFormat:@"%li",(unsigned long)id]};
    
    [self GET:path parameters:parameters success:^(NSURLSessionDataTask* task, NSDictionary* JSON){
        // Block success
        dispatch_queue_t jsonParsing = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(jsonParsing, ^{
            TrafficEvent* trafficEvent = [[TrafficEvent alloc] initWithJSONDictionary:JSON];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(block){
                    block(trafficEvent,nil);
                }
            });
        });
        
        // End of success block
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"Error : %@",error);
        
        // Si block, callback vers le block
        if(block){
            block(nil,error);
        }
    }];
    
}

- (void) getRadarById:(NSUInteger)id block:(void (^)(Radar*,NSError*))block {
    NSString* path = [NSString stringWithFormat:@"%@",kRadar];
    
    NSDictionary* parameters = @{@"id":[NSString stringWithFormat:@"%li",(unsigned long)id]};
    
    [self GET:path parameters:parameters success:^(NSURLSessionDataTask* task, NSDictionary* JSON){
        // Block success
        dispatch_queue_t jsonParsing = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(jsonParsing, ^{
            Radar* radar = [[Radar alloc] initWithJSONDictionary:JSON];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(block){
                    block(radar,nil);
                }
            });
        });
        
        // End of success block
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"Error : %@",error);
        
        // Si block, callback vers le block
        if(block){
            block(nil,error);
        }
    }];
    
}

- (void) getCameraById:(NSUInteger)id block:(void (^)(Camera*,NSError*))block {
    NSString* path = [NSString stringWithFormat:@"%@",kCamera];
    
    NSDictionary* parameters = @{@"id":[NSString stringWithFormat:@"%li",(unsigned long)id]};
    
    [self GET:path parameters:parameters success:^(NSURLSessionDataTask* task, NSDictionary* JSON){
        // Block success
        dispatch_queue_t jsonParsing = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        
        dispatch_async(jsonParsing, ^{
            Camera* camera = [[Camera alloc] initWithJSONDictionary:JSON];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if(block){
                    block(camera,nil);
                }
            });
        });
        
        // End of success block
    } failure:^(NSURLSessionDataTask *task, NSError *error){
        NSLog(@"Error : %@",error);
        
        // Si block, callback vers le block
        if(block){
            block(nil,error);
        }
    }];
}

@end