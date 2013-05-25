//
//  LSCameraDetailViewController.h
//  BeRoads
//
//  Created by Quentin Kaiser on 25/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Camera;

@interface LSCameraDetailViewController : UIViewController
@property (nonatomic,strong) Camera* camera;
@property (nonatomic, strong) UIImageView *myImageView;
@end
