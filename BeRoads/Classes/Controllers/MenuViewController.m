//
//  MenuViewController.h
//  BeRoads
//
//  Created by Quentin Kaiser on 07/07/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController()

@property (nonatomic, strong) NSArray *menuItems;
@property (nonatomic, weak) IBOutlet UITableView* tableView;

@end

@implementation MenuViewController
@synthesize menuItems;

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    [self.slidingViewController setHidesBottomBarWhenPushed:true];
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //self.tableView.separatorColor = [UIColor blackColor];
    self.menuItems = [NSArray arrayWithObjects: @"Map", @"Traffic", @"Radars", @"Cameras", @"Settings", @"About", nil];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    float currentVersion = 7.0;
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion)
    {
        CGRect frame = self.view.frame;
        frame.origin.y = 20;
        self.view.frame = frame;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.menuItems count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = NSLocalizedString([self.menuItems objectAtIndex:indexPath.row], [self.menuItems objectAtIndex:indexPath.row]);
    cell.textLabel.font = [UIFont fontWithName:@"System" size:18.000];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [self.menuItems objectAtIndex:indexPath.row]]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menuItems objectAtIndex:indexPath.row]];
    
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone ){
        UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
        
        float currentVersion = 7.0;
        
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= currentVersion)
        {
            [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
            
            if ([identifier isEqualToString:@"Map"]) {
                UIImage *singlePixelImage = [UIImage imageNamed:@"red_navbar"];
                UIImage *resizableImage = [singlePixelImage resizableImageWithCapInsets:UIEdgeInsetsZero];
                [[UINavigationBar appearance] setBackgroundImage:resizableImage forBarMetrics:UIBarMetricsDefault];
            } else if ([identifier isEqualToString:@"Traffic"]) {
                UIImage *singlePixelImage = [UIImage imageNamed:@"blue_navbar"];
                UIImage *resizableImage = [singlePixelImage resizableImageWithCapInsets:UIEdgeInsetsZero];
                [[UINavigationBar appearance] setBackgroundImage:resizableImage forBarMetrics:UIBarMetricsDefault];
            } else if ([identifier isEqualToString:@"Radars"]) {
                UIImage *singlePixelImage = [UIImage imageNamed:@"orange_navbar"];
                UIImage *resizableImage = [singlePixelImage resizableImageWithCapInsets:UIEdgeInsetsZero];
                [[UINavigationBar appearance] setBackgroundImage:resizableImage forBarMetrics:UIBarMetricsDefault];
            } else if ([identifier isEqualToString:@"Cameras"]) {
                UIImage *singlePixelImage = [UIImage imageNamed:@"green_navbar"];
                UIImage *resizableImage = [singlePixelImage resizableImageWithCapInsets:UIEdgeInsetsZero];
                [[UINavigationBar appearance] setBackgroundImage:resizableImage forBarMetrics:UIBarMetricsDefault];
            } else{
                UIColor* radarsColor = [UIColor grayColor];
                [[UINavigationBar appearance] setBarTintColor:radarsColor];
                [[UINavigationBar appearance] setBackgroundColor:radarsColor];
                [[UINavigationBar appearance] setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            }
        } else{
            if ([identifier isEqualToString:@"Map"]) {
                UIColor* mapColor = [UIColor colorWithRed:1.000000F green:0.235294F blue:0.282353F alpha:1.0F];
                [[UINavigationBar appearance] setBackgroundColor:mapColor];
                [[UINavigationBar appearance] setTintColor:mapColor];
            } else if ([identifier isEqualToString:@"Traffic"]) {
                UIColor* trafficColor = [UIColor colorWithRed:0.215686F green:0.713725F blue:0.890196F alpha:1.0F];
                [[UINavigationBar appearance] setBackgroundColor:trafficColor];
                [[UINavigationBar appearance] setTintColor:trafficColor];
            } else if ([identifier isEqualToString:@"Radars"]) {
                UIColor* radarsColor = [UIColor colorWithRed:0.996078F green:0.729412F blue:0.266667F alpha:1.0F];
                [[UINavigationBar appearance] setBackgroundColor:radarsColor];
                [[UINavigationBar appearance] setTintColor:radarsColor];
            } else if ([identifier isEqualToString:@"Cameras"]) {
                UIColor* camerasColor = [UIColor colorWithRed:0.568627F green:0.803922F blue:0.192157F alpha:1.0F];
                [[UINavigationBar appearance] setBackgroundColor:camerasColor];
                [[UINavigationBar appearance] setTintColor:camerasColor];
            } else{
                UIColor* radarsColor = [UIColor grayColor];
                [[UINavigationBar appearance] setBackgroundColor:radarsColor];
                [[UINavigationBar appearance] setTintColor:radarsColor];
            }
        }
        
        [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
            CGRect frame = self.slidingViewController.topViewController.view.frame;
            self.slidingViewController.topViewController = newTopViewController;
            self.slidingViewController.topViewController.view.frame = frame;
            [self.slidingViewController resetTopView];
        }];

    }
    
    //TODO : manage iPad split views
    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
    {
        //[self.slidingViewController.navigationController pushViewController:[self.storyboard instantiateViewControllerWithIdentifier:identifier] animated:YES];
    }
}

@end