//
//  LSNoResultView.m
//  BeRoads
//
//  Created by student5303 on 5/07/13.
//  Copyright (c) 2013 Lionel Schinckus. All rights reserved.
//

#import "LSNoResultView.h"

@interface LSNoResultView ()

//@property (nonatomic,strong)

@end

@implementation LSNoResultView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
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
