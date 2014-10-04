//
//  InitialSlidingViewController.h
//  BeRoads
//
//  Created by Quentin Kaiser on 07/07/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "InitialSlidingViewController.h"

@implementation InitialSlidingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.topViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Map"];
    }

}

@end
