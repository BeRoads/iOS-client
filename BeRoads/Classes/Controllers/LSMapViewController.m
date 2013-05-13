//
//  LSMapViewController.m
//  BeRoads
//
//  Created by Lionel Schinckus on 12/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSMapViewController.h"

@interface LSMapViewController ()

@end

@implementation LSMapViewController

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
	// Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    LSLocationManager* locationManager = [LSLocationManager sharedLocationManager];
    [locationManager addDelegate:self];
}

-(void)viewWillDisappear:(BOOL)animated{
    LSLocationManager* locationManager = [LSLocationManager sharedLocationManager];
    [locationManager removeDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib{
    self.title = NSLocalizedString(@"Map", @"Map");
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    NSLog(@"MapVC didUpdateLocation %@",newLocation);
}

@end
