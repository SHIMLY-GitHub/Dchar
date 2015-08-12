//
//  SmartSteps.h
//  DChar
//
//  Created by iMuse on 15-8-12.
//  Copyright (c) 2015年 mySelf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartSteps : NSObject
+(SmartSteps*) singleton;
+(void)makResult:(NSString*) newMin andMax:(NSString*)newMax andSec:(int) section andExpon:(int) expon;
@end
