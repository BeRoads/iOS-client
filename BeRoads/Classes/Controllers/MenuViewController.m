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

@end

@implementation MenuViewController
@synthesize menuItems;

- (void)awakeFromNib
{
    self.menuItems = [NSArray arrayWithObjects: @"Map", @"Traffic", @"Radars", @"Webcams", @"Settings", @"About", nil];
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    
    [self.slidingViewController setAnchorRightRevealAmount:280.0f];
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
    [self.slidingViewController setHidesBottomBarWhenPushed:true];
    //self.slidingViewController.view.backgroundColor = [UIColor darkGrayColor];
    //self.view.backgroundColor = [UIColor darkGrayColor];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return [self.menuItems count];
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    // This will create a "invisible" footer
    return 0.01f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *cellIdentifier = @"MenuItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    //TODO : select color that fits the BeRoads UI guidelines
    //cell.contentView.backgroundColor = [UIColor darkGrayColor];
    //cell.textLabel.textColor = [UIColor whiteColor];
    //cell.textLabel.backgroundColor = [UIColor clearColor];
    //cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    [cell.textLabel setHighlightedTextColor: [UIColor whiteColor]];
    
    cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];
    [cell.imageView setFrame:CGRectMake(0, 0, 20, 20)];
    cell.imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", [self.menuItems objectAtIndex:indexPath.row]]];
    cell.imageView.contentMode =  UIViewContentModeScaleAspectFill;
    cell.imageView.clipsToBounds = YES;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menuItems objectAtIndex:indexPath.row]];
    
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    
    [self.slidingViewController anchorTopViewOffScreenTo:ECRight animations:nil onComplete:^{
        CGRect frame = self.slidingViewController.topViewController.view.frame;
        self.slidingViewController.topViewController = newTopViewController;
        self.slidingViewController.topViewController.view.frame = frame;
        [self.slidingViewController resetTopView];
    }];
}

@end