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
    
    UIStoryboard *storyboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPhone" bundle:nil];
        self.topViewController = [storyboard instantiateViewControllerWithIdentifier:@"Map"];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        storyboard = [UIStoryboard storyboardWithName:@"Main_iPad" bundle:nil];
       
    }

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return YES;
}

@end
