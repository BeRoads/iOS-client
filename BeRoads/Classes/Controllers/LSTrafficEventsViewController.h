//
//  LSTrafficEventsViewController.h
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface LSTrafficEventsViewController : UITableViewController

- (IBAction)revealMenu:(id)sender;
@property (nonatomic,strong) NSArray* trafficEvents;

@end
