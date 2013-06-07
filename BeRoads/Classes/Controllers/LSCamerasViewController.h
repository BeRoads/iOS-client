//
//  LSCamerasViewController.h
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PullTableView.h"

@interface LSCamerasViewController : UITableViewController <LSLocationManagerDelegate>

@property (nonatomic,strong) NSArray* cameras;

@end
