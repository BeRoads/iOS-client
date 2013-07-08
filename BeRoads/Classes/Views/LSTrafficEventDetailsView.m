//
//  LSBeRoadsCell.m
//  BeRoads
//
//  Created by Lionel Schinckus on 20/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSTrafficEventDetailsView.h"


@implementation LSTrafficEventDetailsView

@synthesize trafficEvent;
@synthesize locationLabel;
@synthesize messageLabel;
@synthesize lastUpdateLabel;
@synthesize sourceLabel;

- (void)baseInit {
    NSLog(@"Custom view");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self baseInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        [self baseInit];
    }
    return self;
}

- (void) setTrafficEvent:(TrafficEvent *) event {
   
    self.trafficEvent = event;
    [locationLabel setText:[self.trafficEvent location]];
    [messageLabel setText:[self.trafficEvent message]];
    [sourceLabel setText:[self.trafficEvent source]];
    
    
}

@end