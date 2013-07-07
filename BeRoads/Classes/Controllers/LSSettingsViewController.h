//
//  LSSettingsViewController.h
//  BeRoads
//
//  Created by Lionel Schinckus on 29/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "ECSlidingViewController.h"
#import "MenuViewController.h"
#import "IASKAppSettingsViewController.h"

@interface LSSettingsViewController : IASKAppSettingsViewController <IASKSettingsDelegate>

- (IBAction)revealMenu:(id)sender;

@end
