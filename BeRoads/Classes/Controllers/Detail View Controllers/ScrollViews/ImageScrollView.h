
/*
     File: ImageScrollViewController.h
 Abstract: View controller to manage a scrollview that displays a zoomable image.
 
 */

#import "UIImageView+AFNetworking.h"
#import "UITabBarController+UITabBarController_HideTabBar.h"

@interface ImageScrollView : UIScrollView

- (void)displayImage:(UIImage *)image;

@end

