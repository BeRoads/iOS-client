//
//  UITabBarController+UITabBarController_HideTabBar.h
//  yourfestivals_ios
//
//  Created by Lionel Schinckus on 9/12/12.
//  Copyright (c) 2012 Lionel Schinckus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (UITabBarController_HideTabBar)

@property (nonatomic, getter=isTabBarHidden) BOOL tabBarHidden;

- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated;

@end
