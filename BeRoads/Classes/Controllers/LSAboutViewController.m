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
        self.slidingViewController.underLeftViewController  = [self.storyboard instantiateViewControllerWithIdentifier:LSMainStoryboardIDs.viewControllers.menu];
    }
    
    [self.view addGestureRecognizer:[self.slidingViewController panGesture]];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 320, 100)];
    // 48 x 48
    UIImageView* beRoadsImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Icon"]];
    beRoadsImageView.frame = CGRectMake(136, 20, 48, 48);
    // 320 x 21
    UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 74, 320, 21)];
    label.text = @"www.beroads.com";
    label.textAlignment = NSTextAlignmentCenter;
    [self.tableView.tableHeaderView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openBeRoadsURL:)]];
    [self.tableView.tableHeaderView addSubview:beRoadsImageView];
    [self.tableView.tableHeaderView addSubview:label];
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
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0;
}

#pragma mark - Navigation

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary* contact = self.contacts[indexPath.row];
    [[UIApplication sharedApplication] openURL:contact[@"url"]];
}

- (IBAction)openBeRoadsURL:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.beroads.com"]];
}


@end
