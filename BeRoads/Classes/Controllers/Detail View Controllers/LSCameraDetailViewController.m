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

@interface LSCameraDetailViewController ()

@property (nonatomic, strong) UIImageView *myImageView;

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
    
    UIImage *myScreenShot = [UIImage imageNamed:@"Default.png"];
    self.myImageView = [[UIImageView alloc] initWithImage:myScreenShot];
    UIImageView *img = self.myImageView;
    [self.myImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.camera.img]]
                          placeholderImage:[UIImage imageNamed:@"placeholder-cell"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       img.image = image;
                                   } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       NSLog(@"Error : %@",error);
                                   }];
    //set the frame for the image view
    CGRect myFrame = CGRectMake(0, 0, self.myImageView.frame.size.width,
                                self.myImageView.frame.size.height/2);
    [self.myImageView setFrame:myFrame];
    
    //If your image is bigger than the frame then you can scale it
    [self.myImageView setContentMode:UIViewContentModeScaleAspectFit];
    
    //add the image view to the current view
    [self.view addSubview:self.myImageView];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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


@end
