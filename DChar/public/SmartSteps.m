//
//  SmartSteps.m
//  DChar
//
//  Created by iMuse on 15-8-12.
//  Copyright (c) 2015年 mySelf. All rights reserved.
//

#import "SmartSteps.h"
#define ln10 2.302585092994
#define myMin(a,b,c) (a<b?(a<c?a:c):(b<c?b:c))

@implementation SmartSteps
static SmartSteps *_singleton;
+(SmartSteps*) singleton
{
    if (_singleton == nil) {
        _singleton = [[self alloc] init];
    }
    return _singleton;
}

-(id)init
{
    if (self) {
        
    }
    return self;
}
+(void)makResult:(NSString*) newMin andMax:(NSString*)newMax andSec:(int) section andExpon:(int) expon
{
    double doubleNewMin = [newMin doubleValue];
    double doubleNewMax = [newMax doubleValue];
    
    NSDictionary * expStep = [self expNum:[NSString stringWithFormat:@"%f",(doubleNewMax-doubleNewMin)/section] digit:@"-1" byFloor:0];
    NSDictionary * expMin  = [self expNum:newMin digit:@"-1" byFloor:1];
    NSDictionary * expMax  = [self expNum:newMax digit:@"-1" byFloor:0];
    int  numberStepE = [[expStep valueForKey:@"e"] intValue];
    int  numberMinE  =  [[expMin valueForKey:@"e"] intValue];
    int  numberMaxE  =  [[expMax valueForKey:@"e"] intValue];
   
    
   int minExp = myMin(numberMinE,numberStepE,numberMaxE);
    
    if ([[expMin valueForKey:@"c"] doubleValue]==0) {
        minExp = MIN(numberStepE, numberMaxE);
    }else if ([[expMax valueForKey:@"c"] doubleValue]==0){
        minExp = MIN(numberStepE, numberMinE);
    }
    
   expStep =  [self expFixTo:expStep :@{@"c": @"0",@"e":[NSNumber numberWithInt:minExp]} :0];
   expMin  =  [self expFixTo:expMin :expStep :1];
   expMax  =  [self expFixTo:expMax :expStep :0];
    
   
   
    expon += minExp;
    
    
    
    
}
+(NSDictionary*) expFixTo:(NSDictionary*) expnum1 :(NSDictionary*) expnum2 :(int)_byFlooor
{
    int expnum2E = [[expnum2 valueForKey:@"e"]intValue];
    int expnum1E = [[expnum1 valueForKey:@"e"]intValue];
    double expnum1C = [[expnum1 valueForKey:@"c"] doubleValue];
    int deltaExp = expnum2E-expnum1E;
    
    
    if (deltaExp) {
        expnum1E += deltaExp;
        expnum1C *=pow(10, -deltaExp);
        
        expnum1C = _byFlooor ? floor(expnum1C) : ceil(expnum1C);
        
    }
    return @{@"c":[NSNumber numberWithDouble:expnum1C],@"e":[NSNumber numberWithInt:expnum1E] };
}


+(NSDictionary*) expNum :(NSString*)_number digit:(NSString*) _digit byFloor:(int)_byFloor
{
   
    int  digit = [_digit intValue];
    digit =  round(digit%10) ? round(digit%10) : 2;
    
    double  num = [_number doubleValue];
    
    if (digit<0) {
    
        if ([self is_int:_number]) {
           
            NSString * digitString = [NSString stringWithFormat:@"%d",abs([_number intValue])];
            NSString * string = [self removeFinalZoom:digitString];
            digit = string.length ? string.length : 1;
           
        }else
        {
         
         
            
          NSString* numberLength = [[self removeFinalZoom:_number] stringByReplacingOccurrencesOfString:@"." withString:@""];
            
            
          digit = numberLength.length;
           
            
            num = +num;
        
           
        }
    }
    int expon = floor(log(fabs(num))/ln10)-digit+1;
    
    
    
    NSString * cNumberString =  [self roundUp:+(num * pow(10, -expon))afterPoint:15];
    
    double cNumber = [cNumberString doubleValue];
    
    cNumber = _byFloor ? floor(cNumber) : ceil(cNumber);
    
    !cNumber && (expon=0);
    if ([NSString stringWithFormat:@"%d",abs(cNumber)].length>digit) {
        expon +=1;
        cNumber /=10;
    }
    NSDictionary * dic = @{@"c":[NSNumber numberWithDouble:cNumber],@"e":[NSNumber numberWithInt:expon]};
    
    return dic;
    
}


+(NSString*)removeFinalZoom:(NSString *) string
{
    if (![[string substringFromIndex:string.length-1] isEqualToString:@"0"]) {
        return string;
    }else{
       return  [self removeFinalZoom:[string substringToIndex:string.length-1]];
    }
}
+(BOOL)is_int:(NSString*) string
{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int  intValue;
   
    return [scan scanInt:&intValue] && [scan isAtEnd];
}

+(NSString *)roundUp:(double)number afterPoint:(int)position{
    NSDecimalNumberHandler* roundingBehavior = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundUp scale:position raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:NO];
    NSDecimalNumber *ouncesDecimal;
    NSDecimalNumber *roundedOunces;
    ouncesDecimal = [[NSDecimalNumber alloc] initWithFloat:number];
    roundedOunces = [ouncesDecimal decimalNumberByRoundingAccordingToBehavior:roundingBehavior];

    return [NSString stringWithFormat:@"%@",roundedOunces];
}

@end
