//
//  LSCameraDetailViewController.m
//  BeRoads
//
//  Created by Quentin Kaiser on 25/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSCameraDetailViewController.h"
#import "UIImageView+AFNetworking.h"

#import "Camera.h"
#import "ImageScrollView.h"

@interface LSCameraDetailViewController ()

@property (nonatomic, strong) UIImageView *myImageView;
@property (strong, nonatomic) IBOutlet ImageScrollView *imageScrollView;

@end

@implementation LSCameraDetailViewController

@synthesize myImageView;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.navigationItem.title = self.camera.city;
    self.title = self.camera.city;
    
    UIImageView *img = [[UIImageView alloc] init];
    [img setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.camera.img]]
                          placeholderImage:[UIImage imageNamed:@"Default"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       [_imageScrollView displayImage:image];
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"Error : %@",error);
                                   }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated{
    [self addObserver:self forKeyPath:@"camera" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)viewWillDisappear:(BOOL)animated{
    [self removeObserver:self forKeyPath:@"camera"];
}


- (void)viewDidUnload {
    [self setImageScrollView:nil];
    [super viewDidUnload];
}
@end
