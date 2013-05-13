//
// Copyright devmob (Martin Stolz) | devmob.de
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//    http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/**
 * Initially named DMLocationManager and developped by martinstolz
 * Modified By Lionel Schinckus and renamed LSLocationManager
 * It was migrated to ARC by Lionel Schinckus
 * Added distanceFilter
 * The loop is stopped when stopUpdating is called and loop goes to NO
 *
 *
 * The LSLocationManager is a convinience wrapper for the CLLocationManager.
 * It accepts multiple delegate instances at one time.
 *
 *		LSLocationManager* locationManager = [LSLocationManager sharedLocationManager];
 *		[locationManager addDelegate:self];
 *		[locationManager removeDelegate:self];
 *
 * To avoid bad accuracy of location the property 'queryingInterval' defines how long to search for a location with the desired accuracy.
 *
 *		LSLocationManager* locationManager = [LSLocationManager sharedLocationManager];
 *		locationManager.desiredAccuracy	   = kCLLocationAccuracyNearestTenMeters
 *		locationManager.queryingInterval   = 10.0;
 *
 * To avoid getting cached location coordinates deactivate it by setting NO to 'useCache' property.
 *
 *		LSLocationManager* locationManager = [LSLocationManager sharedLocationManager];
 *		locationManager.useCache		   = NO;
 *
 * The 'cacheAge' defines how old a location is allowed to be.
 *
 *		LSLocationManager* locationManager = [LSLocationManager sharedLocationManager];
 *		locationManager.cacheAge	   = 10.0;
 *
 * If nessecary the property 'updateLocationOnApplicationDidBecomeActive' can be used to allow the update of the location on application (re-)start.
 *
 *		LSLocationManager* locationManager							= [LSLocationManager sharedLocationManager];
 *		locationManager.updateLocationOnApplicationDidBecomeActive	= YES;
 *
 * To keep the location permanent up to date the property 'loop' defines whether to repeadeatly determine new location coordinates.
 * The property 'loopTimeInterval' defines how long to sleep between determining the location successfully and beginning the next determination.
 *
 *		LSLocationManager* locationManager = [LSLocationManager sharedLocationManager];
 *		locationManager.loop			   = YES;
 *		locationManager.loopTimeInterval   = 10.0;
 *
 *
 *
 * How it works:
 *
 * Use location manager singleton instance:
 *
 *		LSLocationManager* locationManager = [LSLocationManager sharedLocationManager];
 *
 * Listen for changes by setting delegate instance:
 *
 *		[locationManager addDelegate:self];
 *
 * Make listening instance optionally conform to LSLocationManagerDelegate:
 *
 *		- (void)locationManager:(LSLocationManager*)manager didChangeLocationServiceEnabledState:(BOOL)isLocationServiceEnabled {
 *		}
 *
 *		- (void)locationManagerWillUpdateLocation:(LSLocationManager*)manager {
 *		}
 *
 *		- (void)locationManagerDidStopUpdateLocation:(LSLocationManager*)manager {
 *		}
 *      
 *      - (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
 *      }
 *
 * Start determine location:
 *
 *		[locationManager startUpdatingLocation];
 *
 * Stop determine location on leaving a view e.g.:
 *
 *		[locationManager stopUpdatingLocation];
 *
 * Stop listening for location changes:
 *
 *		[locationManager removeDelegate:self];
 *
 * Activate logging by setting the log level define e.g.:
 *
 *		#define DM_LOCATION_MANAGER_LOG_LEVEL	DM_LOCATION_MANAGER_LOG_LEVEL_INFO
 */

@protocol LSLocationManagerDelegate;


#pragma mark -
#pragma mark LSLocationManager

#define	DM_LOCATION_MANAGER_LOG_LEVEL_NONE		0
#define	DM_LOCATION_MANAGER_LOG_LEVEL_INFO		1
#define	DM_LOCATION_MANAGER_LOG_LEVEL_WARNING	2
#define	DM_LOCATION_MANAGER_LOG_LEVEL_ERROR		3
#define	DM_LOCATION_MANAGER_LOG_LEVEL_DEBUG		4

#define DM_LOCATION_MANAGER_LOG_LEVEL			DM_LOCATION_MANAGER_LOG_LEVEL_DEBUG

@interface LSLocationManager : NSObject <CLLocationManagerDelegate>
{
@private
	NSMutableArray*		_delegates;			// Delegate instances which must be served
	
	CLLocationManager*	_locationManager;	// Shared location manager instance
	CLLocation*			_location;
	BOOL				_useCache;
	NSTimeInterval		_cacheAge;
	BOOL				_isLocationServiceEnabled;
	
	BOOL				_updateLocationOnApplicationDidBecomeActive;
	
	BOOL				_loop;
	NSTimeInterval		_loopTimeInterval;
	NSTimer*			_loopTimer;			// Restart searching of new locations after one was found
	
    BOOL				_useQueryingTimer;
	NSTimeInterval		_queryingInterval;
	NSTimer*			_queryingTimer;		// On timeout the updating of location will be stopped
}

/**
 * Last determined location by location manager. If nil the location was or could not be updated.
 */
@property (nonatomic, strong, readonly) CLLocation*						location;

/**
 * The accuracy which should be aimed. If the accuracy is the desired one, the updating process will be stopped before the query time is reached.
 * Default is -1.
 */
@property (nonatomic, assign)			CLLocationAccuracy				desiredAccuracy;

/**
 * The minimum distance (measured in meters) a device must move horizontally before an update event is generated.
 * Default is kCLDistanceFilterNone
 */
@property (nonatomic, assign) CLLocationDistance distanceFilter;

/**
 * Determines how long the location manager must search for new locations with desired accuracy.
 * Default is 10 seconds.
 */
@property (nonatomic, assign)			NSTimeInterval					queryingInterval;

/**
 * Returns whether the location manager currently searches for new locations.
 */
@property (nonatomic, assign, readonly) BOOL							isQuerying;

/**
 * If YES the last cached location of location manager will be used, which could be some days ago.
 * Default is NO.
 */
@property (nonatomic, assign)			BOOL							useCache;

/**
 * The threshold until the location manager uses the cached location of core location manager.
 * Default is 10 seconds.
 */
@property (nonatomic, assign)			NSTimeInterval					cacheAge;

/**
 * Returns whether the location service of the device is activated. If the application is not allowed this value will be updated by the first search of new location.
 */
@property (nonatomic, assign, readonly) BOOL							isLocationServiceEnabled;

/**
 * If YES the delegates will be informed of location service state changes and a new location will be searched on (re-) activation of the app.
 * Default is NO.
 */
@property (nonatomic, assign)			BOOL							updateLocationOnApplicationDidBecomeActive;

/**
 * Repeat searching for new locations after a location was determined.
 * Default is NO.
 */
@property (nonatomic, assign)			BOOL							loop;

/**
 * Repeat querying for location
 * Default is NO.
 */
@property (nonatomic, assign)			BOOL							useQueryingTimer;


/**
 * After which amount of time after finding a location the search should be restarted
 * Default is 10 seconds.
 */
@property (nonatomic, assign)			NSTimeInterval					loopTimeInterval;

/**
 * Returns the shared instance.
 */
+ (LSLocationManager*) sharedLocationManager;

/**
 * Add a delegate of kind LSLocationManagerDelegate which must be served.
 *
 * @see LSLocationManagerDelegate
 */
- (void)addDelegate:(id<LSLocationManagerDelegate>) delegate;

/**
 * Remove a delegate of kind LSLocationManagerDelegate which must not be served.
 *
 * @see LSLocationManagerDelegate
 */
- (void)removeDelegate:(id<LSLocationManagerDelegate>) delegate;

/**
 * Start updating the location
 */
- (void)startUpdatingLocation;

/**
 * Stop updating the location
 */
- (void)stopUpdatingLocation;

@end


#pragma mark -
#pragma mark LSLocationManagerDelegate

@protocol LSLocationManagerDelegate <CLLocationManagerDelegate>
@optional

/**
 * Informs about changes of location service state.
 *
 * @see LSLocationManager
 */
- (void)locationManager:(LSLocationManager*)manager didChangeLocationServiceEnabledState:(BOOL)isLocationServiceEnabled;

/**
 * Informs when new locations will be started to search for.
 *
 * @see LSLocationManager
 */
- (void)locationManagerWillUpdateLocation:(LSLocationManager*)manager;

/**
 * Informs about stop searching new locations.
 *
 * @see LSLocationManager
 */
- (void)locationManagerDidStopUpdateLocation:(LSLocationManager*)manager;

@end