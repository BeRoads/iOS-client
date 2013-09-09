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
