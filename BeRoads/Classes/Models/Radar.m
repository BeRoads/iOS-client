//
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

// Import
#import "Radar.h"


@implementation Radar


@synthesize idRadar;
@synthesize name;
@synthesize address;
@synthesize lat;
@synthesize lng;
@synthesize date;
@synthesize type;
@synthesize speedLimit;
@synthesize distance;

- (id) initWithJSONDictionary:(NSDictionary *)dic
{
	if(self = [super init])
	{
		[self parseJSONDictionary:dic];
	}
	
	return self;
}

- (void) parseJSONDictionary:(NSDictionary *)dic
{
	// PARSER
    id idRadar_ = [dic objectForKey:@"id"];
    if([idRadar_ isKindOfClass:[NSDecimalNumber class]]){
        self.idRadar = [idRadar_ intValue];
    }
    
	id name_ = [dic objectForKey:@"name"];
	if([name_ isKindOfClass:[NSString class]])
	{
		self.name = name_;
	}
    
    id address_ = [dic objectForKey:@"address"];
	if([address_ isKindOfClass:[NSString class]])
	{
		self.address = address_;
	}

    id lat_ = [dic objectForKey:@"lat"];
    if([lat_ isKindOfClass:[NSNumber class]]){
        self.lat = [lat_ doubleValue];
    } else if([lat_ isKindOfClass:[NSString class]]){
        self.lat = [lat_ doubleValue];
    } else {
        DDLogError(@"Lat is not know, %@, the class is %@",lat_,[lat_ class]);
    }
    
    id lng_ = [dic objectForKey:@"lng"];
    if([lng_ isKindOfClass:[NSNumber class]]){
        self.lng = [lng_ doubleValue];
    } else if([lng_ isKindOfClass:[NSString class]]){
        self.lng = [lng_ doubleValue];
    } else {
        DDLogError(@"Lng is not know, %@, the class is %@",lng_,[lng_ class]);
    }
	

	id date_ = [dic objectForKey:@"date"];
	if([date_ isKindOfClass:[NSString class]])
	{
		self.date = date_;
	}

	id type_ = [dic objectForKey:@"type"];
	if([type_ isKindOfClass:[NSString class]])
	{
		self.type = type_;
	}

    id speedLimit_ = [dic objectForKey:@"speedLimit"];
    if([speedLimit_ isKindOfClass:[NSNumber class]]){
        self.speedLimit = [speedLimit_ intValue];
    } else if ([speedLimit_ isKindOfClass:[NSString class]]) {
        self.speedLimit = [speedLimit_ intValue];
    }
    
    id distance_ = [dic objectForKey:@"distance"];
    if([distance_ isKindOfClass:[NSNumber class]]){
        self.distance = [distance_ intValue];
    } else if([distance_ isKindOfClass:[NSString class]]){
        self.distance = [distance_ intValue];
    }
}

#pragma mark ANNOTATION
-(CLLocationCoordinate2D)coordinate{
    return CLLocationCoordinate2DMake(self.lat, self.lng);
}

- (NSString *)title{
    return address;
}

- (NSString *)subtitle{
    return [NSString stringWithFormat:@"%li - %@",(long)speedLimit,type];
}

@end
