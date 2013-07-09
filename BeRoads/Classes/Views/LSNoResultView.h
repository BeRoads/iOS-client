//
//  LSNoResultView.h
//  BeRoads
//
//  Created by student5303 on 5/07/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSNoResultView : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageTitle;

- (void)showInView:(UIView*)view;

- (void)removeFromView;


@end
