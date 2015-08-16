//
//  NSObject+Dchar.m
//  DChar
//
//  Created by iMuse on 15-8-14.
//  Copyright (c) 2015年 mySelf. All rights reserved.
//

#import "NSObject+Dchar.h"
#import "SmartSteps.h"

@implementation NSObject (Dchar)

-(NSDictionary*)axisyList:(NSString*) min andMax:(NSString*) max
{
    if ([min doubleValue]>=0) {
        min = @"0";
    }
    
  NSDictionary* dic =  [SmartSteps smartSteps:min andMax:max andSection:0 andOpts:nil];
 
    return dic;
    
}
@end
