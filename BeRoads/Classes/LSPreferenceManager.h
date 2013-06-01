//
//  LSPreferenceManager.h
//  BeRoads
//
//  Created by Lionel Schinckus on 1/06/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSPreferenceManager : NSObject

+ (id)defaultManager;
- (void)populateRegistrationDomain;

FOUNDATION_EXPORT NSString* const kAreaPreference;
FOUNDATION_EXPORT NSString* const kClusterPreference;
FOUNDATION_EXPORT NSString* const kTrafficreference;
FOUNDATION_EXPORT NSString* const kRadarPreference;
FOUNDATION_EXPORT NSString* const kCameraPreference;


@end
