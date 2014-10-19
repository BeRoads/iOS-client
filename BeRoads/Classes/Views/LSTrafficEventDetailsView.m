//
//  LSBeRoadsCell.m
//  BeRoads
//
//  Created by Lionel Schinckus on 20/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSTrafficEventDetailsView.h"


@implementation LSTrafficEventDetailsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Do nothing
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    if ((self = [super initWithCoder:aDecoder])) {
        // Do nothing
    }
    return self;
}

- (void)updateUI {
    self.locationLabel.text = [self.trafficEvent location];
    self.messageLabel.text = [self.trafficEvent message];
    self.sourceLabel.text = [self.trafficEvent source];
}

- (void)setTrafficEvent:(TrafficEvent *)trafficEvent {
    _trafficEvent = trafficEvent;
    [self updateUI];
}

@end