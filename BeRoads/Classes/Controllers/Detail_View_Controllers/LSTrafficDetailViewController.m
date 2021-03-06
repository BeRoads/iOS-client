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
#import "PJSDateFormatters.h"
#import <Social/Social.h>

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
    
    NSDate *date = self.trafficEvent.time;
    
    // Date Formatter is very expensive to alloc init, only allow once
    NSDateFormatter* dateFormatter = [[PJSDateFormatters sharedFormatters] dateFormatterWithDateStyle:NSDateFormatterMediumStyle timeStyle:NSDateFormatterShortStyle];
    
    self.updateLabel.text = [dateFormatter stringFromDate:date];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(Share:)];
    }
}

- (IBAction)Share:(id)sender
{
    NSArray *activityItems = @[[NSString stringWithFormat:@"%@ http://beroads.com/event/%li via @BeRoads", self.trafficEvent.location, (long)self.trafficEvent.idTrafficEvent]];
    if ([UIActivityViewController class]) {
        UIActivityViewController *activityController = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
        NSMutableArray* excludedActivityTypes = [NSMutableArray arrayWithArray:@[UIActivityTypeAssignToContact]];
        if([[[UIDevice currentDevice] systemVersion] floatValue] > 7.0){
            [excludedActivityTypes addObjectsFromArray:@[UIActivityTypePostToFlickr, UIActivityTypePostToVimeo]];
        }
        activityController.excludedActivityTypes = excludedActivityTypes;
        [self presentViewController:activityController animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self addObserver:self forKeyPath:@"trafficEvent" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self removeObserver:self forKeyPath:@"trafficEvent"];
}

@end
