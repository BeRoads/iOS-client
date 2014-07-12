//
//  LSAboutViewController.m
//  BeRoads
//
//  Created by student5303 on 20/06/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSAboutViewController.h"

@interface LSAboutViewController ()

@property (nonatomic, strong) NSArray* contacts;
@property (nonatomic, weak) IBOutlet UITableView* tableView;

@end

@implementation LSAboutViewController

#pragma mark - UITableView Controller

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
    
    [self.view addGestureRecognizer:[self.slidingViewController panGesture]];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.contacts = @[
                      @{@"name":@"Christophe Versieux", @"description":@"Android developer", @"image":[UIImage imageNamed:@"waza_be.png"],@"url":[NSURL URLWithString:@"https://plus.google.com/108315424589085456181/posts"]},
                      @{@"name":@"Lionel Schinckus", @"description":@"iOS developer", @"image":[UIImage imageNamed:@"valcapri.png"],@"url":[NSURL URLWithString:@"https://twitter.com/ValCapri"]},
                      @{@"name":@"Julien Winant", @"description":@"Designer", @"image":[UIImage imageNamed:@"harkor.png"],@"url":[NSURL URLWithString:@"http://www.harkor.be"]},
                      @{@"name":@"Quentin Kaiser", @"description":@"Project Manager", @"image":[UIImage imageNamed:@"qkaiser.png" ],@"url":[NSURL URLWithString:@"https://twitter.com/QKaiser"]}
                      ];
    
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu.png"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
    self.navigationItem.leftBarButtonItem = menuButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)awakeFromNib{
    self.title = NSLocalizedString(@"About", @"About");
}

#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contacts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* const contactCellIdentifier = @"contactCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:contactCellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:contactCellIdentifier];
    }
    
    NSDictionary* contact = self.contacts[indexPath.row];
    cell.textLabel.text = contact[@"name"];
    cell.detailTextLabel.text = contact[@"description"];
    cell.imageView.image = contact[@"image"];

    
    return cell;
}

#pragma mark - Navigation

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

- (IBAction)openJulienURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.harkor.be"]];
}

- (IBAction)openBeRoadsURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.beroads.com"]];
}


@end
