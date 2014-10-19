//
//  MenuViewController.h
//  BeRoads
//
//  Created by Quentin Kaiser on 07/07/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "MenuViewController.h"

@interface MenuViewController()

@property (nonatomic, strong) NSDictionary *menuDictionary;
@property (nonatomic, strong) NSArray* menuItems;

@end

@implementation MenuViewController

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    self.menuItems = @[@"Map", @"Traffic", @"Radars", @"Cameras", @"Settings", @"About"];
    self.menuDictionary = @{@"Map":LSMainStoryboardIDs.viewControllers.mapNavigation,
                                 @"Traffic":LSMainStoryboardIDs.viewControllers.trafficNavigation,
                                 @"Radars":LSMainStoryboardIDs.viewControllers.radarsNavigation,
                                 @"Cameras":LSMainStoryboardIDs.viewControllers.camerasNavigation,
                                 @"Settings":LSMainStoryboardIDs.viewControllers.settingsNavigation,
                                 @"About":LSMainStoryboardIDs.viewControllers.aboutNavigation};
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return self.menuItems.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = LSMainStoryboardIDs.reusables.menuItemCell;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = NSLocalizedString(self.menuItems[indexPath.row], self.menuItems[indexPath.row]);
    cell.textLabel.font = [UIFont fontWithName:@"System" size:18.000];
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", self.menuItems[indexPath.row]]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%@", self.menuItems[indexPath.row]];
    
    NSString* navigationIdentifier = self.menuDictionary[identifier];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:navigationIdentifier];
    
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
    
    DDLogVerbose(@"Identifier : %@\nNavigationIdentifier : %@\nnewTopVC : %@",identifier,navigationIdentifier,newTopViewController);
    
    self.slidingViewController.topViewController = newTopViewController;
    
    [self.slidingViewController resetTopViewAnimated:YES onComplete:^{
    }];
}

@end