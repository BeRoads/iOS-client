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
#import "OCAnnotation.h"

@interface LSMapViewController ()

@property (nonatomic,assign) BOOL firstTime;
@property (nonatomic,retain) CLLocation* location;
@property (nonatomic,retain) NSUserDefaults* userDefaults;

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

#pragma mark View Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    _userDefaults = [NSUserDefaults standardUserDefaults];
}

- (void)viewWillAppear:(BOOL)animated{
    _mapView.showsUserLocation = YES;
    
    _mapView.clusteringEnabled = [_userDefaults boolForKey:kClusterPreference];
    
    [_mapView removeAnnotations:_mapView.annotations];
    [self reload];
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

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    // in case it's the user location, we already have an annotation, so just return nil
    if ([annotation isKindOfClass:[MKUserLocation class]])
    {
        return nil;
    }
    
    //handle clustering
    if ([annotation isKindOfClass:[OCAnnotation class]]) {
        OCAnnotation *clusterAnnotation = (OCAnnotation *)annotation;
        
        MKAnnotationView* annotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ClusterView"];
        if (!annotationView) {
            annotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"ClusterView"];
            annotationView.canShowCallout = YES;
            annotationView.centerOffset = CGPointMake(0, -20);
        }
        //calculate cluster region
        CLLocationDistance clusterRadius = self.mapView.region.span.longitudeDelta * self.mapView.clusterSize * 111000 / 2.0f; //static circle size of cluster
        //CLLocationDistance clusterRadius = mapView.region.span.longitudeDelta/log(mapView.region.span.longitudeDelta*mapView.region.span.longitudeDelta) * log(pow([clusterAnnotation.annotationsInCluster count], 4)) * self.mapView.clusterSize * 50000; //circle size based on number of annotations in cluster
        
        MKCircle *circle = [MKCircle circleWithCenterCoordinate:clusterAnnotation.coordinate radius:clusterRadius * cos([annotation coordinate].latitude * M_PI / 180.0)];
        [circle setTitle:@"background"];
        [mapView addOverlay:circle];
        
        MKCircle *circleLine = [MKCircle circleWithCenterCoordinate:clusterAnnotation.coordinate radius:clusterRadius * cos([annotation coordinate].latitude * M_PI / 180.0)];
        [circleLine setTitle:@"line"];
        [mapView addOverlay:circleLine];
        
        // set title
        clusterAnnotation.title = NSLocalizedString(@"Cluster", @"Cluster");
        clusterAnnotation.subtitle = [NSString stringWithFormat:@"%@ : %d",NSLocalizedString(@"Containing annotations", @"Containing annotations"), [clusterAnnotation.annotationsInCluster count]];
        
        // set its image
        annotationView.image = [UIImage imageNamed:@"camera.png"];
        
        // change pin image for group
        if (self.mapView.clusterByGroupTag) {
            if ([clusterAnnotation.groupTag isEqualToString:@"Radar"]) {
                annotationView.image = [UIImage imageNamed:@"radar"];
            }
            else if([clusterAnnotation.groupTag isEqualToString:@"TrafficEvent"]){
                annotationView.image = [UIImage imageNamed:@"accident"];
            }
            else if([clusterAnnotation.groupTag isEqualToString:@"Camera"]){
                annotationView.image = [UIImage imageNamed:@"camera"];
            }
            clusterAnnotation.title = clusterAnnotation.groupTag;
        }
        return annotationView;
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
            customAnnotationView.image = [UIImage imageNamed:@"camera"];
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
            customAnnotationView.image = [UIImage imageNamed:@"accident"];
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
            customAnnotationView.image = [UIImage imageNamed:@"radar"];
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
        
        [self reload];
        
        MKCoordinateSpan span = MKCoordinateSpanMake(0.5, 0.5);
        MKCoordinateRegion region = MKCoordinateRegionMake(userLocation.coordinate, span);
        
        NSLog(@"User loation : %@",_mapView.userLocation);
                
        [_mapView setRegion:region animated:YES];
        [_mapView regionThatFits:region];
        _firstTime = YES;
    }
}

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id <MKOverlay>)overlay{
    MKCircle *circle = overlay;
    MKCircleView *circleView = [[MKCircleView alloc] initWithCircle:overlay];
    
    /*if ([circle.title isEqualToString:@"background"])
    {
        circleView.fillColor = [UIColor yellowColor];
        circleView.alpha = 0.25;
    }
    else if ([circle.title isEqualToString:@"helper"])
    {
        circleView.fillColor = [UIColor redColor];
        circleView.alpha = 0.25;
    }
    else
    {
        circleView.strokeColor = [UIColor blackColor];
        circleView.lineWidth = 0.5;
    }*/
    
    return circleView;
}

- (void)mapView:(MKMapView *)aMapView regionDidChangeAnimated:(BOOL)animated{
    [self.mapView removeOverlays:self.mapView.overlays];
    [self.mapView doClustering];
}

@end
