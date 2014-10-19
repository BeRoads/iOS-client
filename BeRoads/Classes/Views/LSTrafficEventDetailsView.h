//
//  LSBeRoadsCell.h
//  BeRoads
//
//  Created by Lionel Schinckus on 20/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TrafficEvent.h"

@interface LSTrafficEventDetailsView : UIView

@property (strong, nonatomic) TrafficEvent *trafficEvent;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastUpdateLabel;
@property (weak, nonatomic) IBOutlet UILabel *sourceLabel;

@end
