//
//  LSTrafficDetailViewController.m
//  BeRoads
//
//  Created by Lionel Schinckus on 22/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSTrafficDetailViewController.h"

#import "TrafficEvent.h"
#import "MarqueeLabel.h"
#import <Social/Social.h>
#import <SIAlertView/SIAlertView.h>

@interface LSTrafficDetailViewController ()

@end

@implementation LSTrafficDetailViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    MarqueeLabel *continuousLabel = [[MarqueeLabel alloc] initWithFrame:CGRectMake(10, 300, self.view.frame.size.width-20, 20) rate:100.0f andFadeLength:10.0f];
    continuousLabel.tag = 102;
    continuousLabel.marqueeType = MLContinuous;
    continuousLabel.numberOfLines = 1;
    continuousLabel.opaque = NO;
    continuousLabel.enabled = YES;
    continuousLabel.shadowOffset = CGSizeMake(0.0, -1.0);
    continuousLabel.textAlignment = NSTextAlignmentCenter;
    continuousLabel.textColor = [UIColor whiteColor];
    continuousLabel.backgroundColor = [UIColor clearColor];
    continuousLabel.font = [UIFont fontWithName:@"System" size:18.000];
    continuousLabel.text = self.trafficEvent.location;
    [self.navigationItem setTitleView:continuousLabel];

    
    self.sourceLabel.text = self.trafficEvent.source;
    self.descriptionTextView.text = self.trafficEvent.message;
    
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:self.trafficEvent.time];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"MMM dd, yyyy HH:mm"];
    self.updateLabel.text = [format stringFromDate:date];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(Share:)];
}

- (IBAction)Share:(id)sender
{
    SIAlertView *alertView = [[SIAlertView alloc] initWithTitle:@"Share" andMessage:@"Choose your social network"];
    
    [alertView addButtonWithTitle:@"Facebook"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
                                  SLComposeViewController *fbSheetOBJ = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
                                  
                                  [fbSheetOBJ setInitialText:[NSString stringWithFormat:@"%@ http://beroads.com/event/%i via @BeRoads", self.trafficEvent.location, self.trafficEvent.idTrafficEvent]];
                                  [fbSheetOBJ addURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://beroads.com/event/%i", self.trafficEvent.idTrafficEvent]]];
                                  [fbSheetOBJ addImage:[UIImage imageNamed:@"http://beroads.com/assets/img/logo.png"]];
                                  [self presentViewController:fbSheetOBJ animated:YES completion:Nil];
                              }
                              else
                              {
                                  UIAlertView *alertView = [[UIAlertView alloc]
                                                            initWithTitle:@"Sorry"
                                                            message:@"You can't send a facebook post right now, make sure your device has an internet connection and you have at least one Facebook account setup"
                                                            delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                                  [alertView show];
                              }
                              
                          }];
    [alertView addButtonWithTitle:@"Twitter"
                             type:SIAlertViewButtonTypeDefault
                          handler:^(SIAlertView *alert) {
                              if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
                              {
                                  SLComposeViewController *tweetSheetOBJ = [SLComposeViewController
                                                                            composeViewControllerForServiceType:SLServiceTypeTwitter];
                                  [tweetSheetOBJ setInitialText:[NSString stringWithFormat:@"%@ http://beroads.com/event/%i via @BeRoads", self.trafficEvent.location, self.trafficEvent.idTrafficEvent]];
                                  [self presentViewController:tweetSheetOBJ animated:YES completion:nil];
                              }
                              else
                              {
                                  UIAlertView *alertView = [[UIAlertView alloc]
                                                            initWithTitle:@"Sorry"
                                                            message:@"You can't send a tweet right now, make sure your device has an internet connection and you have at least one Twitter account setup"
                                                            delegate:self
                                                            cancelButtonTitle:@"OK"
                                                            otherButtonTitles:nil];
                                  [alertView show];
                              }
                          }];
    [alertView addButtonWithTitle:@"Cancel" type:SIAlertViewButtonTypeCancel handler:^(SIAlertView *alertView) {
        [alertView dismissAnimated:true];
    }];
    
    alertView.transitionStyle = SIAlertViewTransitionStyleBounce;
    [alertView show];
    
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self addObserver:self forKeyPath:@"trafficEvent" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self removeObserver:self forKeyPath:@"trafficEvent"];
}

@end
