//
//  LSMapViewController.m
//  BeRoads
//
//  Created by Lionel Schinckus on 12/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSMapViewController.h"
#import "Camera.h"
#import "TrafficEvent.h"
#import "Radar.h"
#import "LSBeRoadsClient.h"

#import "LSTrafficDetailViewController.h"
#import "LSCameraDetailViewController.h"

@interface LSMapViewController ()

@property (nonatomic,assign) BOOL firstTime;
@property (nonatomic,retain) CLLocation* location;
@property (nonatomic,retain) NSUserDefaults* userDefaults;

@end

@implementation LSMapViewController

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _userDefaults = [NSUserDefaults standardUserDefaults];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
    self.navigationItem.leftBarButtonItem = menuButton;
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
    
    _mapView.showsUserLocation = YES;
        
    [_mapView removeAnnotations:_mapView.annotations];
    [self reload];
}

-(void)viewWillDisappear:(BOOL)animated{
    if (_mapView != nil && _mapView.showsUserLocation == YES) {
        _mapView.showsUserLocation = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib{
    self.title = NSLocalizedString(@"Map", @"Map");
}

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark NETWORK CONNECTION

- (void)reload{
    [self reloadCameras];
    [self reloadTrafficEvents];
    [self reloadRadars];
}

- (void)reloadCameras{
    if ([_userDefaults boolForKey:kCameraPreference]) {
        [[LSBeRoadsClient sharedClient] getCameras:^(NSArray * cameras, NSError * error) {
            [_mapView addAnnotations:cameras];
        } location:_location.coordinate];
    }
}

- (void)reloadTrafficEvents{
    if ([_userDefaults boolForKey:kTrafficreference]) {
        [[LSBeRoadsClient sharedClient] getTrafficEvents:^(NSArray * trafficEvents, NSError * error) {
            [_mapView addAnnotations:trafficEvents];
        } location:_location.coordinate];
    }
}

- (void)reloadRadars{
    if ([_userDefaults boolForKey:kRadarPreference]) {
        [[LSBeRoadsClient sharedClient] getRadars:^(NSArray * radars, NSError * error) {
            [_mapView addAnnotations:radars];
        } location:_location.coordinate];
    }
}

#pragma mark MapView Delegate

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    // here we illustrate how to detect which annotation type was clicked on for its callout
    id<MKAnnotation> annotation = [view annotation];

    if ([annotation isKindOfClass:[Camera class]]){
        LSCameraDetailViewController* cameraDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"cameraDetailViewController"];
        cameraDetailViewController.camera = (Camera*)annotation;
        [self.navigationController pushViewController:cameraDetailViewController animated:YES];
    } else if ([annotation isKindOfClass:[TrafficEvent class]]){
        LSTrafficDetailViewController* trafficDetailViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"trafficDetailViewController"];
        trafficDetailViewController.trafficEvent = (TrafficEvent*)annotation;
        [self.navigationController pushViewController:trafficDetailViewController animated:YES];
    }
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    
    // handle our three custom annotations
    //
    if ([annotation isKindOfClass:[Camera class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString *cameraAnnotationIdentifier = @"cameraAnnotationIdentifier";
                
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:cameraAnnotationIdentifier];
        if (annotationView == nil)
        {
            // if an existing pin view was not available, create one
            MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:cameraAnnotationIdentifier];
            customAnnotationView.image = [UIImage imageNamed:@"ic_m_webcam"];
            customAnnotationView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: when the detail disclosure button is tapped, we respond to it via:
            //       calloutAccessoryControlTapped delegate method
            //
            // by using "calloutAccessoryControlTapped", it's a convenient way to find out which annotation was tapped
            //
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customAnnotationView.rightCalloutAccessoryView = rightButton;
            return customAnnotationView;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    else if ([annotation isKindOfClass:[TrafficEvent class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString *trafficEventAnnotationIdentifier = @"trafficEventAnnotationIdentifier";
                
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:trafficEventAnnotationIdentifier];
        if (annotationView == nil)
        {
            // if an existing pin view was not available, create one
            MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:trafficEventAnnotationIdentifier];
            customAnnotationView.image = [UIImage imageNamed:@"ic_m_traffic"];
            customAnnotationView.canShowCallout = YES;
            
            // add a detail disclosure button to the callout which will open a new view controller page
            //
            // note: when the detail disclosure button is tapped, we respond to it via:
            //       calloutAccessoryControlTapped delegate method
            //
            // by using "calloutAccessoryControlTapped", it's a convenient way to find out which annotation was tapped
            //
            UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
            [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
            customAnnotationView.rightCalloutAccessoryView = rightButton;
            
            return customAnnotationView;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    // Radar
    else if ([annotation isKindOfClass:[Radar class]]) // for Golden Gate Bridge
    {
        // try to dequeue an existing pin view first
        static NSString *radarAnnotationIdentifier = @"radarAnnotationIdentifier";
                
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:radarAnnotationIdentifier];
        if (annotationView == nil)
        {
            // if an existing pin view was not available, create one
            MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:radarAnnotationIdentifier];
            customAnnotationView.image = [UIImage imageNamed:@"ic_m_radar"];
            customAnnotationView.canShowCallout = YES;
                        
            return customAnnotationView;
        }
        else
        {
            annotationView.annotation = annotation;
        }
        return annotationView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (!_firstTime && [userLocation.location.timestamp timeIntervalSinceNow] < 30 && userLocation.location.horizontalAccuracy > 0) {
        _location = userLocation.location;
        
        // Let the device know we want to receive push notifications
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
        
        [self reload];
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
        MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, span);
                        
        [_mapView setRegion:region animated:YES];
        [_mapView regionThatFits:region];
        _firstTime = YES;
    }
}

@end
