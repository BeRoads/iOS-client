//
//  LSAboutViewController.m
//  BeRoads
//
//  Created by student5303 on 20/06/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSSideMenuViewController.h"
#import "LSCamerasViewController.h"
#import "LSTrafficEventsViewController.h"
#import "LSRadarsViewController.h"
#import "LSSettingsViewController.h"
#import "LSAboutViewController.h"

@interface LSSideMenuViewController ()

@property (nonatomic, strong) NSArray *menuItems;

@end

@implementation LSSideMenuViewController

@synthesize menuItems;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.layer.borderColor = [UIColor whiteColor].CGColor;
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

- (void)awakeFromNib{
    self.title = NSLocalizedString(@"Navigation", @"Navigation");
    self.menuItems = [NSArray arrayWithObjects: @"Trafic", @"Radars", @"Webcams", @"Settings", @"About", nil];
}

#pragma mark - Table view data source

 - (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
 {
     return self.menuItems.count;
 }
 
 - (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
 {
     NSString *cellIdentifier = @"Cell";
     UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
     if (cell == nil) {
         cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
     }
     //TODO : select color that fits the BeRoads UI guidelines
     cell.contentView.backgroundColor = [UIColor grayColor];
     cell.textLabel.textColor = [UIColor whiteColor];
     cell.textLabel.backgroundColor = [UIColor clearColor];
     cell.detailTextLabel.backgroundColor = [UIColor clearColor];
     [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
     [cell.textLabel setHighlightedTextColor: [UIColor whiteColor]];
     
     cell.textLabel.text = [self.menuItems objectAtIndex:indexPath.row];     
     
     return cell;

 }
 

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [NSString stringWithFormat:@"%@", [self.menuItems objectAtIndex:indexPath.row]];
    UIViewController *newTopViewController = [self.storyboard instantiateViewControllerWithIdentifier:identifier];
    [self.navigationController pushViewController:newTopViewController animated:true];
}

@end
