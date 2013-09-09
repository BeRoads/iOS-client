//
//  LSAboutViewController.m
//  BeRoads
//
//  Created by student5303 on 20/06/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSAboutViewController.h"

@interface LSAboutViewController ()

@end

@implementation LSAboutViewController


- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)openChristopheURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://plus.google.com/108315424589085456181/posts"]];
}

- (IBAction)openQuentinURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/QKaiser"]];
}

- (IBAction)openJulienURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.harkor.be"]];
}

- (IBAction)openLionelURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.valcapri.com"]];
}

- (IBAction)openBeRoadsURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.beroads.com"]];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    // shadowPath, shadowOffset, and rotation is handled by ECSlidingViewController.
    // You just need to set the opacity, radius, and color.
    self.navigationController.view.layer.shadowOpacity = 0.75f;
    self.navigationController.view.layer.shadowRadius = 10.0f;
    self.navigationController.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:@"Menu"];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
        self.navigationItem.leftBarButtonItem = menuButton;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib{
    self.title = NSLocalizedString(@"About", @"About");
}


@end
