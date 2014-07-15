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

@end
