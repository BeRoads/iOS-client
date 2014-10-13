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
    
    self.menuItems = [NSArray arrayWithObjects: @"Map", @"Traffic", @"Radars", @"Cameras", @"Settings", @"About", nil];
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
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    
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
    
    self.slidingViewController.topViewController = newTopViewController;
    //[self.slidingViewController.topViewController showViewController:newTopViewController sender:self.view];
    
    [self.slidingViewController resetTopViewAnimated:YES onComplete:^{
    }];
}

@end