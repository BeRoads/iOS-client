//
//  LSBeRoadsClient.m
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSBeRoadsClient.h"

#import <AFNetworking.h>

#import "Cameras.h"
#import "TrafficEvents.h"
#import "Radars.h"

@implementation LSBeRoadsClient

static NSString * const kBeRoadsBaseURLString = @"http://data.beroads.com/IWay/";
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

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    return self;
}

#pragma mark GET_FROM_REST

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
            NSDictionary* dict = [JSON objectForKey:@"TrafficEvent"];
            TrafficEvents* trafficEventsObject = [[TrafficEvents alloc] initWithJSONDictionary:dict];
            NSArray* trafficEvents = [trafficEventsObject item];
                        
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
            NSDictionary* dict = [JSON objectForKey:@"Radar"];
            Radars* radarsObject = [[Radars alloc] initWithJSONDictionary:dict];
            NSArray* radars = [radarsObject item];
            
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
            NSDictionary* dict = [JSON objectForKey:@"Camera"];
            Cameras* camerasObject = [[Cameras alloc] initWithJSONDictionary:dict];
            NSArray* cameras = [camerasObject item];
            
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

@end