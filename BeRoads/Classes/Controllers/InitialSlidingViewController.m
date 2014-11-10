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
    self.splitViewController.preferredPrimaryColumnWidthFraction = 0.5;
}

- (void)collapseSecondaryViewController:(UIViewController *)secondaryViewController forSplitViewController:(UISplitViewController *)splitViewController {
    //DDLogVerbose(@"SVC : %@\nsecondVC : %@\nPrimaryVC : %@\nTopVC : %@\nTrait : %@",splitViewController,secondaryViewController,splitViewController.viewControllers[0],self.topViewController,[InitialSlidingViewController sizeClassesAsString:self.splitViewController.traitCollection.horizontalSizeClass]);
    if ([self.topViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)self.topViewController;
        [navigationController showViewController:secondaryViewController sender:nil];
    }
}

- (UIViewController *)separateSecondaryViewControllerForSplitViewController:(UISplitViewController *)splitViewController {
    //UIViewController* secondaryVC = splitViewController.viewControllers.count > 1 ? splitViewController.viewControllers[1]:nil;
    //DDLogVerbose(@"SVC : %@\nsecondVC : %@\nPrimaryVC : %@\nTopVC : %@\nTrait : %@",splitViewController,secondaryVC,splitViewController.viewControllers[0],self.topViewController,[InitialSlidingViewController sizeClassesAsString:self.splitViewController.traitCollection.horizontalSizeClass]);
    if ([self.topViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)self.topViewController;
        UIViewController* viewController = [navigationController popViewControllerAnimated:YES];
        return viewController;
    }
    return nil;
}

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

- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender {
    //DDLogVerbose(@"SVC : %@\nVC : %@\nSender : %@\nTopVC : %@\nTrait : %@",splitViewController,vc,sender,self.topViewController,[InitialSlidingViewController sizeClassesAsString:self.splitViewController.traitCollection.horizontalSizeClass]);
    if ([self.topViewController isKindOfClass:[UINavigationController class]] && self.splitViewController.collapsed) {
        UINavigationController* navigationController = (UINavigationController*)self.topViewController;
        [navigationController showViewController:vc sender:sender];
        return YES;
    }
    return NO;
}

- (void)showViewController:(UIViewController *)vc sender:(id)sender {
    //DDLogVerbose(@"SVC : %@\nVC : %@\nSender : %@\nTopVC : %@\nTrait : %@",self.splitViewController,vc,sender,self.topViewController,[InitialSlidingViewController sizeClassesAsString:self.splitViewController.traitCollection.horizontalSizeClass]);
    if ([self.topViewController isKindOfClass:[UINavigationController class]] && self.splitViewController.collapsed) {
        UINavigationController* navigationController = (UINavigationController*)self.topViewController;
        [navigationController showViewController:vc sender:sender];
    }
}

+ (NSString*)sizeClassesAsString:(UIUserInterfaceSizeClass)sizeClass{
    NSString* sizeClassString = @"";
    switch (sizeClass) {
        case UIUserInterfaceSizeClassRegular:
            sizeClassString = @"Regular";
            break;
        case UIUserInterfaceSizeClassCompact:
            sizeClassString = @"Compact";
            break;
        case UIUserInterfaceSizeClassUnspecified:
            sizeClassString = @"Unspecified";
            break;
            
        default:
            break;
    }
    return sizeClassString;
}

@end
