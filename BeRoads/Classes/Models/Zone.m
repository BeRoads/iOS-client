//
//  Zone.m
//  BeRoads
//
//  Created by Lionel Schinckus on 27/05/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "Zone.h"

@implementation Zone

- (NSString *)description{
    return [NSString stringWithFormat:@"%@ - %lu",_title,(unsigned long)[_cameras count]];
}

@end
