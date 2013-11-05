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
    if([lat_ isKindOfClass:[NSDecimalNumber class]]){
        self.lat = [lat_ doubleValue];
    }
    
    id lng_ = [dic objectForKey:@"lng"];
    if([lat_ isKindOfClass:[NSDecimalNumber class]]){
        self.lng = [lng_ doubleValue];
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
    if([speedLimit_ isKindOfClass:[NSDecimalNumber class]]){
        self.speedLimit = [speedLimit_ intValue];
    }
    
    id distance_ = [dic objectForKey:@"distance"];
    if([distance_ isKindOfClass:[NSDecimalNumber class]]){
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
    return [NSString stringWithFormat:@"%i - %@",speedLimit,type];
}

@end
