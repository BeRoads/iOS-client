//
//  LSTrafficDetailViewController.h
//  BeRoads
//
//  Created by Lionel Schinckus on 22/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrafficEvent;

@interface LSTrafficDetailViewController : UITableViewController

@property (nonatomic,strong) TrafficEvent* trafficEvent;

@end
