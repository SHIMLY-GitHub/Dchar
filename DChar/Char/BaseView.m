//
//  BaseView.m
//  DChar
//
//  Created by iMuse on 15-8-6.
//  Copyright (c) 2015年 mySelf. All rights reserved.
//

#import "BaseView.h"
@implementation BaseView
@synthesize charRect;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
    self.charRect = rect;
    
}


@end
