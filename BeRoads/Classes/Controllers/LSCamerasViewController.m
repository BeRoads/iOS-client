//
//  LSCamerasViewController.m
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSCamerasViewController.h"

#import "Camera.h"
#import "Zone.h"

#import "LSLocationManager.h"
#import "LSBeRoadsClient.h"

#import "CSNotificationView+AFNetworking.h"

#import <UIImageView+AFNetworking.h>
#import <UIRefreshControl+AFNetworking.h>
#import <FSImageViewer.h>
#import <FSBasicImage.h>
#import <FSBasicImageSource.h>

@interface LSCamerasViewController ()

@property (nonatomic, strong) NSArray* zones;

@property (nonatomic, strong) FSImageViewerViewController *imageViewController;
@property (nonatomic, strong) UINavigationController* imageNavigationController;

@end

@implementation LSCamerasViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu"] style:UIBarButtonItemStyleBordered target:self action:@selector(revealMenu:)];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    // Empty DataSet
    self.tableView.emptyDataSetDelegate = self;
    self.tableView.emptyDataSetSource = self;
    
    // A little trick for removing the cell separators
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self reloadCameras];
}

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
}

- (void)reloadCameras{
    [[LSBeRoadsClient sharedClient] getCameras:^(NSArray * cameras, NSError * error, NSURLSessionDataTask* task) {
        self.cameras = cameras;
        [self createZones];
        [self.tableView reloadData];
        
        [CSNotificationView showNotificationViewForTaskWithErrorOnCompletion:task controller:self];
        [self.refreshControl setRefreshingWithStateOfTask:task];
    } location:[[LSLocationManager sharedLocationManager] location].coordinate];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)awakeFromNib{
    self.title = NSLocalizedString(@"Cameras", @"Cameras");
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.zones count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[self.zones objectAtIndex:section] cameras] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"beroadsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [cell addGestureRecognizer:longPressGesture];
    
    __block UITableViewCell* weakCell = cell;
    
    // Configure the cell...
    Camera* currentCamera = [[[self.zones objectAtIndex:indexPath.section] cameras] objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:currentCamera.img_thumb]]
                          placeholderImage:[UIImage imageNamed:@"placeholder_cell"]
    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        weakCell.imageView.image = image;
        [weakCell setNeedsLayout];
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
        NSLog(@"Error : %@",error);
    }];
    
    cell.textLabel.text = currentCamera.city;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Camera* selectedCamera = [self.zones[indexPath.section] cameras][indexPath.row];
    FSBasicImage* imageBasic = [[FSBasicImage alloc] initWithImageURL:[NSURL URLWithString:selectedCamera.img]];
    FSBasicImageSource* imageSource = [[FSBasicImageSource alloc] initWithImages:@[imageBasic]];
    self.imageViewController = [[FSImageViewerViewController alloc] initWithImageSource:imageSource];
    self.imageNavigationController = [[UINavigationController alloc] initWithRootViewController:self.imageViewController];
    [self.splitViewController showDetailViewController:self.imageNavigationController sender:self.tableView];
}


- (void)longPress:(UILongPressGestureRecognizer *)gesture
{
	// only when gesture was recognized, not when ended
	if (gesture.state == UIGestureRecognizerStateBegan)
	{
		// get affected cell
		UITableViewCell *cell = (UITableViewCell *)[gesture view];
        
		// get indexPath of cell
		NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        //get the camera's zone
        Zone* selectedZone = [self.zones objectAtIndex:indexPath.section];
        //get the selected camera
        Camera* selectedCamera = [[[self.zones objectAtIndex:indexPath.section] cameras] objectAtIndex:indexPath.row];
        
        //retrieve user's preferences
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSMutableArray *mutableArrayCopy = [[prefs objectForKey:@"webcams_favorites"] mutableCopy];
        //if there is no favorites array, we create it
        if(!mutableArrayCopy){
            mutableArrayCopy = [[NSMutableArray alloc] init];
            [prefs setObject:[[NSArray alloc] init] forKey:@"webcams_favorites"];
        }
        
        bool present = false;
        for(NSData *cameraEncodedObject in mutableArrayCopy){
            Camera *camera = [NSKeyedUnarchiver unarchiveObjectWithData:cameraEncodedObject];
            if([camera idCamera] == [selectedCamera idCamera])
                present = true;
        }
     
        NSData *cameraEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:selectedCamera];
        //if it's not already stored as favorites
        if(!present && ![[selectedZone title] isEqualToString:NSLocalizedString(@"Favorites", @"Favorites")]){
            DDLogVerbose(@"Added element at row %@", indexPath);
            [mutableArrayCopy addObject:cameraEncodedObject];
        }
        else if(present && [[selectedZone title] isEqualToString:NSLocalizedString(@"Favorites", @"Favorites")]){
            //it's already in favorites and he push in the favorites zone so we delete it
            [mutableArrayCopy removeObject:cameraEncodedObject];
        }
        //we copy to a NSArray so NSUserDefaults don't get angry
        NSArray *array = [NSArray arrayWithArray:mutableArrayCopy];
        [prefs setObject:array forKey:@"webcams_favorites"];
        //we update the favorites zone view
        [self updateFavorites];
        
	}
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [[self.zones objectAtIndex:section] title];
}

- (void) updateFavorites{
    /**
     Get the favorites zone and set the cameras NSArray to the content stored in NSUserDefaults as "webcams_favorites".
     If the favorite zone don't exists, it does nothin'
     **/
    for(Zone* z in _zones){
        if([[z title] isEqualToString:NSLocalizedString(@"Favorites", @"Favorites")]){
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            NSMutableArray *mutableArrayCopy = [[prefs objectForKey:@"webcams_favorites"] mutableCopy];
            NSMutableArray *webcams_favorites = [[NSMutableArray alloc] init];
            if(mutableArrayCopy){
                for(NSData *cameraEncodedObject in mutableArrayCopy){
                    [webcams_favorites addObject:[NSKeyedUnarchiver unarchiveObjectWithData:cameraEncodedObject]];
                }
            }
            z.cameras = webcams_favorites;
        }
    }
    [self.tableView reloadData];
    
}

- (void)createZones{
    NSMutableArray* zonesMutable = [NSMutableArray array];
    NSArray* titlesZones = [_cameras valueForKeyPath:@"@distinctUnionOfObjects.zone"];
    
    Zone* zone = [[Zone alloc] init];
    zone.title = NSLocalizedString(@"Favorites", @"Favorites");
    [zonesMutable addObject:zone];
    
    for (NSString* title in titlesZones) {
        Zone* zone = [[Zone alloc] init];
        zone.title = title;
        NSPredicate* predicate = [NSPredicate predicateWithFormat:@"zone LIKE %@",title];
        zone.cameras = [_cameras filteredArrayUsingPredicate:predicate];
        [zonesMutable addObject:zone];
    }
    
    _zones = [NSArray arrayWithArray:zonesMutable];
    [self updateFavorites];
}

#pragma mark - Empty DataSource

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"NoResultTitle", @"No Result Title")];
}

- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    return [[NSAttributedString alloc] initWithString:NSLocalizedString(@"NoResultDescription", @"No Result Description")];
}

#pragma mark IBActions

- (IBAction)pullTableViewDidTriggerRefresh:(id)sender
{
    [self reloadCameras];
}

- (IBAction)revealMenu:(id)sender
{
    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionCentered) {
        [self.slidingViewController anchorTopViewToRightAnimated:YES];
    } else {
        [self.slidingViewController resetTopViewAnimated:YES];
    }
}

@end