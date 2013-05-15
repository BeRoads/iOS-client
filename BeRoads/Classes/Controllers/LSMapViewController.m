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

@interface LSMapViewController ()

@property (nonatomic,assign) BOOL firstTime;

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
    _mapView.showsUserLocation = YES;
    [self reloadCameras];
    [self reloadTrafficEvents];
    [self reloadRadars];
}

- (void)reloadCameras{
    [[LSBeRoadsClient sharedClient] getCameras:^(NSArray * cameras, NSError * error) {
        [_mapView addAnnotations:cameras];
    }];
}

- (void)reloadTrafficEvents{
    [[LSBeRoadsClient sharedClient] getTrafficEvents:^(NSArray * trafficEvents, NSError * error) {
        [_mapView addAnnotations:trafficEvents];
    }];
}

- (void)reloadRadars{
    [[LSBeRoadsClient sharedClient] getRadars:^(NSArray * radars, NSError * error) {
        [_mapView addAnnotations:radars];
    }];
}

-(void)viewWillDisappear:(BOOL)animated{
    _mapView.showsUserLocation = NO;
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

- (void)viewDidUnload {
    [self setMapView:nil];
    [super viewDidUnload];
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
        
        NSLog(@"pass a camera");
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:cameraAnnotationIdentifier];
        if (annotationView == nil)
        {
            // if an existing pin view was not available, create one
            MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:cameraAnnotationIdentifier];
            customAnnotationView.image = [UIImage imageNamed:@"Camera"];
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
        
        NSLog(@"pass a camera");
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:trafficEventAnnotationIdentifier];
        if (annotationView == nil)
        {
            // if an existing pin view was not available, create one
            MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:trafficEventAnnotationIdentifier];
            customAnnotationView.image = [UIImage imageNamed:@"Accident"];
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
        
        NSLog(@"pass a camera");
        
        MKAnnotationView *annotationView = (MKAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:radarAnnotationIdentifier];
        if (annotationView == nil)
        {
            // if an existing pin view was not available, create one
            MKAnnotationView *customAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:radarAnnotationIdentifier];
            customAnnotationView.image = [UIImage imageNamed:@"Radar"];
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
    return nil;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation{
    if (!_firstTime) {
        MKCoordinateSpan span = MKCoordinateSpanMake(1, 1);
        MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, span);
        
        NSLog(@"User loation : %@",_mapView.userLocation);
                
        [_mapView setRegion:region animated:YES];
        [_mapView regionThatFits:region];
        _firstTime = YES;
    }
}

@end
