//
//  LSTrafficDetailViewController.h
//  BeRoads
//
//  Created by Lionel Schinckus on 22/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TrafficEvent;

@interface LSTrafficDetailViewController : UIViewController

@property (nonatomic,strong) TrafficEvent* trafficEvent;
@property (nonatomic,strong) IBOutlet UILabel* updateLabel;
@property (nonatomic,strong) IBOutlet UITextView* descriptionTextView;
@property (nonatomic,strong) IBOutlet UILabel* sourceLabel;


@end
