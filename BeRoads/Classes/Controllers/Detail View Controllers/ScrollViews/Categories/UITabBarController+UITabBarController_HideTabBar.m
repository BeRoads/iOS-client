//
//  UITabBarController+UITabBarController_HideTabBar.m
//  yourfestivals_ios
//
//  Created by Lionel Schinckus on 9/12/12.
//  Copyright (c) 2012 Lionel Schinckus. All rights reserved.
//

#import "UITabBarController+UITabBarController_HideTabBar.h"

#define kAnimationDuration .3

@implementation UITabBarController (UITabBarController_HideTabBar)

- (BOOL)isTabBarHidden {
	CGRect viewFrame = self.view.frame;
	CGRect tabBarFrame = self.tabBar.frame;
	return tabBarFrame.origin.y >= viewFrame.size.height;
}


- (void)setTabBarHidden:(BOOL)hidden {
	[self setTabBarHidden:hidden animated:NO];
}


- (void)setTabBarHidden:(BOOL)hidden animated:(BOOL)animated {
	BOOL isHidden = self.tabBarHidden;
	if(hidden == isHidden)
		return;
	UIView *transitionView = [[[self.view.subviews reverseObjectEnumerator] allObjects] lastObject];
	if(transitionView == nil) {
		NSLog(@"could not get the container view!");
		return;
	}
	CGRect viewFrame = self.view.frame;
	CGRect tabBarFrame = self.tabBar.frame;
	CGRect containerFrame = transitionView.frame;
	tabBarFrame.origin.y = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
	containerFrame.size.height = viewFrame.size.height - (hidden ? 0 : tabBarFrame.size.height);
	[UIView animateWithDuration:kAnimationDuration
					 animations:^{
						 self.tabBar.frame = tabBarFrame;
						 transitionView.frame = containerFrame;
					 }
	 ];
}

@end
