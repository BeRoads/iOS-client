//
//  LSMapViewController.h
//  BeRoads
//
//  Created by Lionel Schinckus on 12/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface LSMapViewController : UIViewController <LSLocationManagerDelegate,MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
