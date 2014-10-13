//
//  InitialSlidingViewController.h
//  BeRoads
//
//  Created by Quentin Kaiser on 07/07/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "InitialSlidingViewController.h"
#import "LSTrafficDetailViewController.h"

@implementation InitialSlidingViewController

- (void)viewDidLoad {
    self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Map"];
    self.splitViewController.delegate = self;
    self.splitViewController.preferredPrimaryColumnWidthFraction = 0.5f;
    [super viewDidLoad];
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
    if ([secondaryViewController isKindOfClass:[LSTrafficDetailViewController class]]) {
        LSTrafficDetailViewController* trafficDetailViewController = (LSTrafficDetailViewController*)secondaryViewController;
        if (trafficDetailViewController.trafficEvent == nil) {
            NSLog(@"Collapse secondary : YES");
            return YES;
        }
    }
    NSLog(@"Collapse secondary : NO");
    return NO;
}

- (BOOL)splitViewController:(UISplitViewController *)splitViewController showDetailViewController:(UIViewController *)vc sender:(id)sender {
    NSLog(@"SVC : %@\nVC : %@\nSender : %@\nTopVC : %@\nTrait : %@",splitViewController,vc,sender,self.topViewController,[InitialSlidingViewController sizeClassesAsString:self.splitViewController.traitCollection.horizontalSizeClass]);
    if ([self.topViewController isKindOfClass:[UINavigationController class]] && self.splitViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact) {
        UINavigationController* navigationController = (UINavigationController*)self.topViewController;
        [navigationController pushViewController:vc animated:YES];
        return YES;
    } else if(![vc isKindOfClass:[UINavigationController class]] && self.splitViewController.traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassRegular) {
        UINavigationController* navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
        [splitViewController showDetailViewController:navigationController sender:sender];
        return YES;
    }
    return NO;
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
