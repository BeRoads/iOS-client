//
//  InitialSlidingViewController.h
//  BeRoads
//
//  Created by Quentin Kaiser on 07/07/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "InitialSlidingViewController.h"
#import "LSTrafficEventDetailViewController.h"

@implementation InitialSlidingViewController

- (void)viewDidLoad {
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:LSMainStoryboardIDs.viewControllers.mapNavigation];
    self.splitViewController.delegate = self;
    [super viewDidLoad];
    self.splitViewController.minimumPrimaryColumnWidth = 300;
    self.splitViewController.maximumPrimaryColumnWidth = 600;
    self.splitViewController.preferredPrimaryColumnWidthFraction = 0.5f;
}

#pragma mark - SplitViewController Delegate
- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    //DDLogVerbose(@"SVC : %@\nsecondVC : %@\nPrimaryVC : %@\nTopVC : %@\nTrait : %@",splitViewController,secondaryViewController,primaryViewController,self.topViewController,[InitialSlidingViewController sizeClassesAsString:self.splitViewController.traitCollection.horizontalSizeClass]);
    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [((UINavigationController*)secondaryViewController).topViewController isKindOfClass:[LSTrafficEventDetailViewController class]]) {
        LSTrafficEventDetailViewController* trafficDetailViewController = (LSTrafficEventDetailViewController*)((UINavigationController*)secondaryViewController).topViewController;
        if (trafficDetailViewController.trafficEvent == nil) {
            return YES;
        }
    }
    return NO;
}

@end
