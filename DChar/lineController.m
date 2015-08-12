//
//  lineController.m
//  DChar
//
//  Created by iMuse on 15-8-5.
//  Copyright (c) 2015年 mySelf. All rights reserved.
//

#import "lineController.h"
#import "LineChar.h"

@interface lineController ()

@end

@implementation lineController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
           
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    LineChar * lineChar = [[LineChar alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    [self.view addSubview:lineChar];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
  
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
 
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIDeviceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
    }
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
   
}



@end
