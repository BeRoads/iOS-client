//
//  LSSettingsViewController.m
//  BeRoads
//
//  Created by Lionel Schinckus on 29/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSSettingsViewController.h"

@interface LSSettingsViewController ()

@end

@implementation LSSettingsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStylePlain target:self action:@selector(revealMenu:)];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.navigationController.view.layer.shadowOpacity = 0.75f;
    self.navigationController.view.layer.shadowRadius = 10.0f;
    self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:LSMainStoryboardIDs.viewControllers.menu];
    }
    
    [self.view addGestureRecognizer:[self.slidingViewController panGesture]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.title = NSLocalizedString(@"Settings", @"Settings");
}

#pragma mark - IBAction

- (IBAction)revealMenu:(id)sender
{
    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
    } else {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}

#pragma mark - Settings Delegate

- (void)settingsViewControllerDidEnd:(IASKAppSettingsViewController *)sender{
    // Do nothing
}

@end
