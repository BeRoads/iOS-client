//
//  LSAppDelegate.m
//  BeRoads
//
//  Created by Lionel Schinckus on 11/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSAppDelegate.h"

#import "LSMapViewController.h"
#import "LSTrafficEventDetailViewController.h"
//#import "LSCameraDetailViewController.h"

#import "LSBeRoadsClient.h"

#import <AFNetworking.h>
#import <AFNetworkActivityIndicatorManager.h>

#if HAS_POD(CrashlyticsFramework)
#import <Crashlytics/Crashlytics.h>
#endif

#if HAS_POD(CocoaLumberjack)
#if __has_include("DDASLLogger.h")
#import <CocoaLumberjack/DDASLLogger.h>
#endif
#if __has_include("DDTTYLogger.h")
#import <CocoaLumberjack/DDTTYLogger.h>
#endif

#import "CrashlyticsLogger.h"

#endif

#if HAS_POD(Aperitif) && IS_ADHOC_BUILD
#import <Aperitif/CRLAperitif.h>
#endif

//#import "PSPDFHangDetector.h"

@implementation LSAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Location manager
    
    [self initializeLoggingAndServices];
    
    // Enable Activity Indicator
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    LSLocationManager* locationManager = [LSLocationManager sharedLocationManager];
    locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
    locationManager.distanceFilter = 1000; // 1 kilometer
    locationManager.updateLocationOnApplicationDidBecomeActive = YES;
    locationManager.loop = YES;
    locationManager.loopTimeInterval = 300;
    [locationManager startUpdatingLocation];
    
    // The registration domain is volatile.  It does not persist across launches.
    // You must register your defaults at each launch; otherwise you will get
    // (system) default values when accessing the values of preferences the
    // user (via the Settings app) or your app (via set*:forKey:) has not
    // modified.  Registering a set of default values ensures that your app always
    // has a known good set of values to operate on.
    [[LSPreferenceManager defaultManager] populateRegistrationDomain];
    
    //Set the status bar to black color.
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    // Set to navigation bar
    
    // Menu Bar Button Item in white
    [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
    // Back in white
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    // Arrow in white
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    // Navigation bar text color in white
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    // Background color
    UIImage *singlePixelImage = [UIImage imageNamed:@"red_navbar"];
    UIImage *resizableImage = [singlePixelImage resizableImageWithCapInsets:UIEdgeInsetsZero];
    [[UINavigationBar appearance] setBackgroundImage:resizableImage forBarMetrics:UIBarMetricsDefault];
    
    //UIImage *navBar = [UIImage imageNamed:@"navbar.png"];
    //[[UINavigationBar appearance] setBackgroundImage:navBar forBarMetrics:UIBarMetricsDefault];
    
    //[[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    
    if (launchOptions == nil) {
        if([[UIApplication sharedApplication] applicationIconBadgeNumber] > 0){
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    }
    
    // Let the device know we want to receive push notifications
    
    // FIXEME : Handle notification
    /*if (currentVersion >= requiredVersion8) {
#ifdef __IPHONE_8_0
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil]];
#endif
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
         (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }*/
    
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
    
    
    NSString *language = [[[NSBundle mainBundle] preferredLocalizations] objectAtIndex:0];
    NSInteger area = [userDefaults integerForKey:kAreaPreference];
    double latitude = [coordinate coordinate].latitude;
    double longitude = [coordinate coordinate].longitude;
    NSString* deviceTokenString = [[[deviceToken description]
                                    stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
                                   stringByReplacingOccurrencesOfString:@" "
                                   withString:@""];
    
    if (longitude != 0 && latitude != 0) {
        
        NSMutableDictionary*  parametersCoords = [NSMutableDictionary dictionary];
        [parametersCoords setObject:[NSString stringWithFormat:@"%f",latitude] forKey:@"latitude"];
        [parametersCoords setObject:[NSString stringWithFormat:@"%f",longitude] forKey:@"longitude"];
        
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        [parameters setObject:deviceTokenString forKey:@"device_token"];
        [parameters setObject:[NSString stringWithFormat:@"%ld",(long)area] forKey:@"area"];
        [parameters setObject:language forKey:@"language"];
        [parameters setObject:parametersCoords forKey:@"coords"];
        
        DDLogVerbose(@"Device Token (with space) : %@",deviceToken);
        DDLogVerbose(@"URL Request : %@, \n parameters : %@", @"http://dashboard.beroads.com/apns", parameters);
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] init];
        
        [manager POST:@"http://dashboard.beroads.com/apns" parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            DDLogVerbose(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            DDLogError(@"Error: %@", error);
        }];

    } else {
        DDLogVerbose(@"La longitude et la latitude sont égales à 0");
    }
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
    DDLogError(@"Failed to get token, error: %@", error);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    DDLogVerbose(@"Application : %@, open URL : %@, Source Application : %@, Annotation : %@",application,url,sourceApplication,annotation);
    UIStoryboard* storyboard = self.window.rootViewController.storyboard;
    UISplitViewController* splitViewController = (UISplitViewController*)self.window.rootViewController;
    NSString* scheme = [url scheme];
    NSString* host = [url host];
    NSString* trafficId = [url lastPathComponent];
    
    if ([scheme isEqualToString:@"beroads"]) {
        if ([host isEqualToString:@"open"] || [host isEqualToString:@"traffic"]) {
            [[LSBeRoadsClient sharedClient] getTrafficEventById:trafficId block:^(TrafficEvent *trafficEvent, NSError *error) {
                if (error == nil) {
                    UINavigationController* navigationController = [storyboard instantiateViewControllerWithIdentifier:LSMainStoryboardIDs.viewControllers.trafficEventDetailNavigation];
                    LSTrafficEventDetailViewController* trafficDetailViewController = (LSTrafficEventDetailViewController*) navigationController.topViewController;
                    trafficDetailViewController.trafficEvent = trafficEvent;
                    [splitViewController showDetailViewController:navigationController sender:nil];
                } else {
                    DDLogError(@"Error : %@",error);
                }
            }];
        } else if ([host isEqualToString:@"camera"]){
            //LSCameraDetailViewController* cameraDetailViewController = [storyboard instantiateViewControllerWithIdentifier:LSMainStoryboardIDs.viewControllers.cameraDetail];
            //cameraDetailViewController.camera = (Camera*)annotation;
            //[splitViewController showDetailViewController:cameraDetailViewController sender:view];
        }
    }
    return YES;
}

#pragma mark Amaro foundation goodies

/**
 Connects to Crashlytics and sets up CocoaLumberjack
 */
-(void)initializeLoggingAndServices
{
    //[PSPDFHangDetector startHangDetector]; // Smart little helper to find main thread hangs.
    
#if HAS_POD(CrashlyticsFramework)
    NSString *crashlyticsAPIKey = @"3a2322f2e5a421953b38ea0d77076490aba2f9c8";
    
    if([crashlyticsAPIKey characterAtIndex:0] != '<') [Crashlytics startWithAPIKey:crashlyticsAPIKey];
    else NSLog(@"Set your Crashlytics API key in the app delegate to enable Crashlytics integration!");
#endif
    
#if HAS_POD(CocoaLumberjack)
    
    // Emulate NSLog behavior for DDLog*
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Send warning & error messages to Crashlytics
    //[[CrashlyticsLogger sharedInstance] setLogFormatter:logFormatter];

    [DDLog addLogger:[CrashlyticsLogger sharedInstance]];
#endif
}

/**
 Schedules a check for updates to the app in the Installr API. Only executed for Ad Hoc builds,
 not targetting the simulator (i.e. archives of the -Staging and -Production schemes).
 */
-(void)scheduleCheckForUpdates
{
    // Uncomment the blob below and fill in your Installr app tokens to enable automatically
    // prompting the user when a new build of your app is pushed.
    
#if HAS_POD(Aperitif) && IS_ADHOC_BUILD && !TARGET_IPHONE_SIMULATOR && !defined(DEBUG)
    
    //    #ifdef TARGETING_STAGING
    //    NSString * const installrAppToken = @"<Installr app token for the staging build of your app>";
    //    #else
    //    NSString * const installrAppToken = @"<Installr app token for the production build of your app>";
    //    #endif
    //
    //    [CRLAperitif sharedInstance].appToken = installrAppToken;
    //    [[CRLAperitif sharedInstance] checkAfterDelay:3.0];
    
#endif
}



@end
