//
//  LSNoResultView.m
//  BeRoads
//
//  Created by student5303 on 5/07/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSNoResultView.h"

@interface LSNoResultView ()

@property (nonatomic,strong) 

@end

@implementation LSNoResultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, 320, 20)];
        label.backgroundColor = self.backgroundColor;
        label.textColor = [UIColor whiteColor];
        label.text = NSLocalizedString(@"No Results for your location", @"No Results for your location");
        label.textAlignment = UITextAlignmentCenter;
        label.center = self.center;
        [self addSubview:label];
        [self addObserver:self forKeyPath:@"text" options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew context:nil];
    }
    return self;
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"text"];
}

- (void)showInView:(UIView*)view{
    [view addSubview:self];
}

- (void)removeFromView{
    [self removeFromSuperview];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
