//
//  SmartSteps.h
//  DChar
//
//  Created by iMuse on 15-8-12.
//  Copyright (c) 2015年 mySelf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartSteps : NSObject
@property (nonatomic,strong) NSArray * mySections;
@property (nonatomic,strong) NSArray * mySteps;
@property (nonatomic,strong) NSArray * custSection;
@property (nonatomic,strong) NSArray * custSteps;
@property (nonatomic,assign) BOOL minLocked;
@property (nonatomic,assign) BOOL maxLocked;
+(SmartSteps*) singleton;
+(NSDictionary*)makResult:(NSString*) newMin andMax:(NSString*)newMax andSec:(int) section andExpon:(int) expon;
+(NSDictionary*) expNum :(NSString*)_number digit:(NSString*) _digit byFloor:(int)_byFloor;
+(NSDictionary*) bothLocked:(NSString*) min andMax:(NSString*) max andSec:(int) section;

+(NSArray*) cross0:(double) min andMax:(double) max andNewMin:(double) newMin andNewMax:(double) newMax;
+(NSDictionary*) forInteger:(NSString*) min andMax:(NSString *) max andSec:(int) section;

+(NSDictionary*) coreCalc:(NSString*) min andMax:(NSString *) max andSec:(int) section;
+(NSDictionary*) smartSteps:(NSString*) minString andMax:(NSString*) maxString andSection:(int) section andOpts:(NSDictionary*) opts;

@end
