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
#import "LSMapViewController.h"
#if HAS_POD(CrashlyticsFramework)
#import <Crashlytics/Crashlytics.h>
#endif

#if HAS_POD(CocoaLumberjack)
#if HAS_POD(CrashlyticsLumberjack)
#import <CrashlyticsLumberjack/CrashlyticsLogger.h>
#endif

#if HAS_POD(Sidecar)
#import <Sidecar/CRLMethodLogFormatter.h>
#endif
#endif

#if HAS_POD(Aperitif) && IS_ADHOC_BUILD
#import <Aperitif/CRLAperitif.h>
#endif

#if HAS_POD(FlurrySDK)
#import "Flurry.h"
#endif

#import "PSPDFHangDetector.h"

@implementation LSAppDelegate

@synthesize window;
@synthesize navController = _navController;
@synthesize splitViewController = _splitViewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Location manager
    
    [self initializeLoggingAndServices];
    
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
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
    
    // Set to navigation bar
    float requiredVersion7 = 7.0;
    float requiredVersion8 = 8.0;
    float currentVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (currentVersion >= requiredVersion7)
    {
        // Menu Bar Button Item in white
        [[UIBarButtonItem appearance] setTintColor:[UIColor whiteColor]];
        // Back in white
        [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        // Arrow in white
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        // Navigation bar text color in white
        [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        
        // Background color
        UIImage *singlePixelImage = [UIImage imageNamed:@"red_navbar"];
        UIImage *resizableImage = [singlePixelImage resizableImageWithCapInsets:UIEdgeInsetsZero];
        [[UINavigationBar appearance] setBackgroundImage:resizableImage forBarMetrics:UIBarMetricsDefault];
    } else {
        UIColor* mapColor = [UIColor colorWithRed:1.000000F green:0.235294F blue:0.282353F alpha:1.0F];
        [[UINavigationBar appearance] setBackgroundColor:mapColor];
        [[UINavigationBar appearance] setTintColor:mapColor];
    }
    
    //UIImage *navBar = [UIImage imageNamed:@"navbar.png"];
    //[[UINavigationBar appearance] setBackgroundImage:navBar forBarMetrics:UIBarMetricsDefault];
    
    //[[UIBarButtonItem appearance] setTintColor:[UIColor blackColor]];
    
    if (launchOptions == nil) {
        if([[UIApplication sharedApplication] applicationIconBadgeNumber] > 0){
            [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        }
    }
    
    // Let the device know we want to receive push notifications
    if (currentVersion >= requiredVersion8) {
#ifdef __IPHONE_8_0
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert) categories:nil]];
#endif
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
    
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
        
        AFHTTPClient *client = [[AFHTTPClient alloc]initWithBaseURL:url];
        [client registerHTTPOperationClass:[AFHTTPRequestOperation class]];
        [client setParameterEncoding:AFJSONParameterEncoding];
        
        NSMutableURLRequest *request = [client requestWithMethod:@"POST"
                                                            path:@"http://dashboard.beroads.com/apns"
                                                      parameters:parameters];
        
        NSLog(@"Device Token (with space) : %@",deviceToken);
        NSLog(@"URL Request : %@, \n parameters : %@", [request URL], parameters);
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            // Print the response body in text
            NSLog(@"Response: %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
        }];
        [operation start];
    } else {
        NSLog(@"La longitude et la latitude sont égales à 0");
    }
    
	NSLog(@"My token is: %@", deviceTokenString);
}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    NSLog(@"Application : %@, open URL : %@, Source Application : %@, Annotation : %@",application,url,sourceApplication,annotation);
    if ([[url scheme] isEqualToString:@"beroads"]) {
        if ([[url host] isEqualToString:@"open"]) {
            NSLog(@"Fragment : %@", [url lastPathComponent]);
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
    [PSPDFHangDetector startHangDetector]; // Smart little helper to find main thread hangs.
    
#if HAS_POD(CrashlyticsFramework)
    NSString *crashlyticsAPIKey = @"3a2322f2e5a421953b38ea0d77076490aba2f9c8";
    
    if([crashlyticsAPIKey characterAtIndex:0] != '<') [Crashlytics startWithAPIKey:crashlyticsAPIKey];
    else NSLog(@"Set your Crashlytics API key in the app delegate to enable Crashlytics integration!");
#endif
    
#if HAS_POD(CocoaLumberjack)
#if HAS_POD(Sidecar)
    CRLMethodLogFormatter *logFormatter = [[CRLMethodLogFormatter alloc] init];
    [[DDASLLogger sharedInstance] setLogFormatter:logFormatter];
    [[DDTTYLogger sharedInstance] setLogFormatter:logFormatter];
#endif
    
    // Emulate NSLog behavior for DDLog*
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    
    // Send warning & error messages to Crashlytics
#if HAS_POD(CrashlyticsLumberjack)
#if HAS_POD(Sidecar)
    [[CrashlyticsLogger sharedInstance] setLogFormatter:logFormatter];
#endif
    [Flurry startSession:@"5G6J9C6GQMRV4GZ9HRYP"];
    [TestFlight takeOff:@"03c76c2b-de43-48f9-a7f6-7b9530e06416"];
    
    [DDLog addLogger:[CrashlyticsLogger sharedInstance] withLogLevel:LOG_LEVEL_INFO];
#endif
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
