//
//  BaseLineView.m
//  DChar
//
//  Created by iMuse on 15-8-5.
//  Copyright (c) 2015年 mySelf. All rights reserved.
//

#import "BaseLineView.h"

@implementation BaseLineView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = CGRectMake(0, 0, 1024, 768);
        self.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}
-(void) initView
{
    UIView * backgroundView = [[UIView alloc] initWithFrame:CGRectMake(20, 60, 1024-40, 768-120)];
    backgroundView.backgroundColor = [UIColor colorWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1];
    backgroundView.layer.cornerRadius = 5;
    backgroundView.layer.borderWidth = 1;
    backgroundView.layer.borderColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1].CGColor;
    [self addSubview:backgroundView];
    
    UIView * titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 1024, 90)];
    //titleView.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:titleView];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 180, 60)];
    titleLabel.text = @"未来一周气温变化";
    [titleView addSubview:titleLabel];
    titleLabel.textColor = [UIColor colorWithRed:54/255.0f green:133/255.0f blue:197/255.0f alpha:1];
    titleLabel.font = [UIFont systemFontOfSize:20];
    
    UILabel * subTitle = [[UILabel alloc] initWithFrame:CGRectMake(20, titleLabel.frame.size.height-20, 180, 30)];
    subTitle.text = @"纯属虚构";
    subTitle.textColor = [UIColor colorWithRed:154/255.0f green:154/255.0f blue:154/255.0f alpha:1];
    [titleView addSubview:subTitle];
    subTitle.font = [UIFont systemFontOfSize:13];
    
    UIView * borderView = [[UIView alloc] initWithFrame:CGRectMake(60, 90, backgroundView.frame.size.width-120, backgroundView.frame.size.height-180)];
    
    borderView.layer.borderWidth = 1;
    borderView.layer.borderColor = [UIColor colorWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1].CGColor;
    [backgroundView addSubview:borderView];
}


@end
