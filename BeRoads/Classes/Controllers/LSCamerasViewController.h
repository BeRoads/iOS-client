//
//  LSCamerasViewController.h
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import <PullTableView.h>

@interface LSCamerasViewController : UITableViewController <LSLocationManagerDelegate>

- (IBAction)revealMenu:(id)sender;

@property (nonatomic,strong) NSArray* cameras;

@end
