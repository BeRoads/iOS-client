//
//  LSAppDelegate.m
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSAppDelegate.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"

@implementation LSAppDelegate

@synthesize window;
@synthesize navController = _navController;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Location manager
    
    // !!!: Use the next line only during beta
    [TestFlight setDeviceIdentifier:[[UIDevice currentDevice] uniqueIdentifier]];
    
    [TestFlight takeOff:@"03c76c2b-de43-48f9-a7f6-7b9530e06416"];   
    // End TestFlight
    
    LSLocationManager* locationManager = [LSLocationManager sharedLocationManager];
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 1000; // 1 kilometer
    locationManager.updateLocationOnApplicationDidBecomeActive = YES;
    locationManager.loop = YES;
    locationManager.loopTimeInterval = 120;
    [locationManager startUpdatingLocation];
    
    // The registration domain is volatile.  It does not persist across launches.
    // You must register your defaults at each launch; otherwise you will get
    // (system) default values when accessing the values of preferences the
    // user (via the Settings app) or your app (via set*:forKey:) has not
    // modified.  Registering a set of default values ensures that your app always
    // has a known good set of values to operate on.
    [[LSPreferenceManager defaultManager] populateRegistrationDomain];
    
    // Let the device know we want to receive push notifications
	[[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    //Set the status bar to black color.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    UIImage *navBar = [UIImage imageNamed:@"navbar.png"];
    [[UINavigationBar appearance] setBackgroundImage:navBar forBarMetrics:UIBarMetricsDefault];
    
    [[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    LSLocationManager* locationManager = [LSLocationManager sharedLocationManager];
    [locationManager stopUpdatingLocation];
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
   
    //send a request to register the deviceToken to the beroads server so it can send push notification  
    CLLocation* coordinate = [[LSLocationManager sharedLocationManager] location];
    
    NSUserDefaults* userDefaults = [NSUserDefaults standardUserDefaults];
        
    NSURL *url = [NSURL URLWithString:@"http://dashboard.beroads.com/apns"];
    
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    double area = [userDefaults integerForKey:kAreaPreference];
    double latitude = [coordinate coordinate].latitude;
    double longitude = [coordinate coordinate].longitude;
    NSString* deviceTokenString = [[[deviceToken description]
                                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                   stringByReplacingOccurrencesOfString:@" "
                                   withString:@""];
    
    NSMutableDictionary*  parametersCoords = [NSMutableDictionary dictionary];
    [parametersCoords setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
    [parametersCoords setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
    
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    [parameters setObject:deviceTokenString forKey:@"device_token"];
    [parameters setObject:[NSString stringWithFormat:@"%i",area] forKey:@"area"];
    [parameters setObject:language forKey:@"language"];
    [parameters setObject:parametersCoords forKey:@"coords"];
    
    AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
    [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    [client setParameterEncoding:AFJSONParameterEncoding];
    
    NSMutableURLRequest *request = [client requestWithMethod:@"POST"
                                                        path:@"http://dashboard.beroads.com/apns"
                                                  parameters:parameters];
    
    NSLog(@"URL Request : %@", [request URL]);
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        // Print the response body in text
        NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    [operation start];
   
	NSLog(@"My token is: %@", deviceTokenString);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}



@end
