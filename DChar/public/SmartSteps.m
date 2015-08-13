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
        self.mySections = @[@"4",@"5",@"6"];
        self.mySteps = @[@"10",@"20",@"25",@"50"];
    }
    return self;
}

+(NSDictionary*) bothLocked:(NSString*) min andMax:(NSString*) max andSec:(int) section
{
    NSArray * trySecs = nil;
    
    trySecs = section ? @[[NSString stringWithFormat:@"%d",section]] : [SmartSteps singleton].custSection;
    
    double Dmin = [min doubleValue];
    double Dmax = [max doubleValue];
    double span = Dmax-Dmin;
    
    if (span ==0) {
        NSDictionary* dicMax = [self expNum:max digit:@"3" byFloor:0];
        
        double MaxC = [[dicMax valueForKey:@"c"] doubleValue];
        section = [[trySecs objectAtIndex:0] intValue];
        
        return [self makResult:[NSString stringWithFormat:@"%f",MaxC-section] andMax:[NSString stringWithFormat:@"%f",MaxC] andSec:section andExpon:[[dicMax valueForKey:@"e"]intValue] ];
    }
    if (fabs(Dmax/span)< 1e-6) {
        Dmax = 0;
    }
    
    if (fabs(Dmin/span)<1e-6) {
        Dmin = 0;
    }
    
    int step;
    double deltaSpan;
    double score;
    
    NSArray * scoreS = @[@[@"5",@"10"],@[@"10",@"2"],@[@"50",@"10"],@[@"100",@"2"]];
    NSMutableArray * reference = [[NSMutableArray alloc] init];
 
    NSDictionary   * expSpan   = [self expNum:[NSString stringWithFormat:@"%f",Dmax-Dmin] digit:@"3" byFloor:0];
    NSDictionary   * expMin    = [self expNum:[NSString stringWithFormat:@"%f",Dmin] digit:@"-1" byFloor:1];
    NSDictionary   * expMax     = [self expNum:[NSString stringWithFormat:@"%f",Dmax] digit:@"-1" byFloor:0];
    
   expMin =  [self expFixTo:expMin :expSpan :1];
   expMax =  [self expFixTo:expMax :expSpan :0];
    
   Dmax = [[expMax valueForKey:@"c"] doubleValue];
   Dmin = [[expMin valueForKey:@"c"] doubleValue];
   span = Dmax-Dmin;
    
    for (int i=trySecs.count; i--;) {
        section = [[trySecs objectAtIndex:i] intValue];
       
        step = ceil(span/section);
        deltaSpan = step*section-span;
        score = (deltaSpan+3) * 3;
        score += (section-[[trySecs objectAtIndex:0] intValue]+2)*2;
        if (section % 5==0) {
            score -=10;
        }
        for (int j = scoreS.count;j--;) {
            if (step % [[[scoreS objectAtIndex:j] objectAtIndex:0] intValue]==0) {
                score /= [[[scoreS objectAtIndex:j] objectAtIndex:1] intValue];
            }
        }
        reference[i] = @{@"secs": [NSNumber numberWithInt:section],@"step":[NSNumber numberWithDouble:step],@"delta":[NSNumber numberWithDouble:deltaSpan],@"score":[NSNumber numberWithDouble:score]};
        
    }
   
  NSArray* referStore =  [reference sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* dic1,NSDictionary* dic2){
        int score1 = [[dic1 valueForKey:@"score"] intValue];
        int score2 = [[dic2 valueForKey:@"score"] intValue];
        
        return score1-score2;
        
    }];
    
    NSDictionary * refDic = [referStore objectAtIndex:0];
    
    
    
    Dmin = round(Dmin-[[refDic valueForKey:@"delta"] doubleValue]/2);
    Dmax = round(Dmax+[[refDic valueForKey:@"delta"] doubleValue]/2);
  
    
    NSDictionary * returnDic = [self makResult:[NSString stringWithFormat:@"%f",Dmin] andMax:[NSString stringWithFormat:@"%f",Dmax] andSec:[[refDic valueForKey:@"secs"]intValue] andExpon:[[expSpan valueForKey:@"e"] intValue]];
    
    return  returnDic;
    
}
+(NSDictionary*)makResult:(NSString*) newMin andMax:(NSString*)newMax andSec:(int) section andExpon:(int) expon
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
    
    doubleNewMax = [[expMax valueForKey:@"c"] doubleValue];
    doubleNewMin = [[expMin valueForKey:@"c"] doubleValue];
    
    double step = (doubleNewMax-doubleNewMin)/section;
    
   
    
    double zoom = pow(10, expon);
    int fixTo = 0;
    NSMutableArray * pointArray = [[NSMutableArray alloc] init];
    for (int i=section+1; i--;) {
        
        [pointArray addObject:[NSNumber numberWithDouble:(doubleNewMin+step*i)*zoom]];
    }
    
    if (expon<0) {
        fixTo = [self decimals:zoom];
        step =  [[self roundUp:+(step*zoom) afterPoint:fixTo] doubleValue];
        doubleNewMin = [[self roundUp:+(doubleNewMin*zoom) afterPoint:fixTo] doubleValue];
        doubleNewMax = [[self roundUp:+(doubleNewMax*zoom) afterPoint:fixTo] doubleValue];
        
        for (int i=pointArray.count; i--;) {
            
            pointArray[i]= [self roundUp:[[pointArray objectAtIndex:i] doubleValue] afterPoint:fixTo];
        }
    }else{
        doubleNewMax *= zoom;
        doubleNewMin *= zoom;
        step         *= zoom;
    }
    
    NSDictionary * dic = @{@"min":[NSNumber numberWithDouble:doubleNewMin],@"max":[NSNumber numberWithDouble:doubleNewMax],@"secs":[NSNumber numberWithInt:section],@"step":[NSNumber numberWithDouble:step],@"fix":[NSNumber numberWithInt:fixTo],@"exp":[NSNumber numberWithInt:expon],@"pnts":pointArray};
    
  
    return dic;
    
    
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

+(NSInteger) decimals:(double) number
{
    NSString * numberString = [NSString stringWithFormat:@"%f",number];
    NSArray  * numberArray =  [numberString componentsSeparatedByString:@"."];
    NSString * string =   [numberArray objectAtIndex:1];
    
   return [self removeFinalZoom:string].length;
    
}
+(NSArray*) cross0:(double) min andMax:(double) max andNewMin:(double) newMin andNewMax:(double) newMax
{
    if (min >= 0 && newMin<0) {
        
        newMax -= newMin;
        newMin  = 0;
        
    }else if (max <=0 && newMax>0){
        newMin -= newMax;
        newMax = 0;
    }
    return @[[NSNumber numberWithDouble:newMin],[NSNumber numberWithDouble:newMax]];
}
+(NSDictionary*) forInteger:(NSString*) min andMax:(NSString *) max andSec:(int) section
{
    double Dmin = [min doubleValue];
    double Dmax = [max doubleValue];
    section = section ? section : 5;
    if ([SmartSteps singleton].minLocked) {
        
        Dmax = Dmin + section;
    }else if ([SmartSteps singleton].maxLocked)
    {
        Dmin = Dmax - section;
    }else
    {
        double delta = section -(Dmax-Dmin);
        double newMin = round(Dmin-delta/2);
        double newMax = round(Dmax+delta/2);
        
        NSArray * arrMM = [self cross0:Dmin andMax:Dmax andNewMin:newMin andNewMax:newMax];
        Dmin = [[arrMM objectAtIndex:0] doubleValue];
        Dmax = [[arrMM objectAtIndex:1] doubleValue];
        
    }
    
    return [self makResult:[NSString stringWithFormat:@"%f",Dmin] andMax:[NSString stringWithFormat:@"%f",Dmax] andSec:section andExpon:0];
}
+(NSDictionary*) coreCalc:(NSString*) min andMax:(NSString *) max andSec:(int) section
{
    double step;
    NSArray* secsArr = [SmartSteps singleton].custSection;
    
    NSArray * stepArr = [SmartSteps singleton].custSteps;
    
    int location = secsArr.count-1;
    int secs = section ? section : [[secsArr objectAtIndex:location] intValue];
    
    double Dmin = [min doubleValue];
    double Dmax = [max doubleValue];
    
    NSDictionary * expStep = [self getCeil:[NSString stringWithFormat:@"%f",(Dmax-Dmin)/secs] andRounds:stepArr];
    
    NSDictionary * expSpan = [self expNum:[NSString stringWithFormat:@"%f",Dmax-Dmin] digit:@"0" byFloor:0];
    
    NSDictionary * expMin = [self expNum:[NSString stringWithFormat:@"%f",Dmin] digit:@"-1" byFloor:1];
    NSDictionary * expMax = [self expNum:[NSString stringWithFormat:@"%f",Dmax] digit:@"-1" byFloor:0];
    
    
    
    expSpan = [self expFixTo:expSpan :expStep :0];
    expMin  = [self expFixTo:expMin :expStep :1];
    expMax  = [self expFixTo:expMax :expStep :0];
    
    NSDictionary * currentDic = nil;
    
    if (!section) {
        currentDic = [self look4sections:expMin andMax:expMax];
        secs = [[currentDic valueForKey:@"section"] intValue];
    }else{
        
        currentDic = [self look4step:expMin andMax:expMax andSecs:secs];
        step = [[currentDic valueForKey:@"step"] doubleValue];
    }
    expMin = [currentDic valueForKey:@"expMin"];
    expMax = [currentDic valueForKey:@"expMax"];
    
    if (Dmax-Dmin<secs) {
            return [self forInteger:min andMax:max andSec:secs];
        }
    
    secs = [self tryForInt:min andMax:max andSection:section andExpMax:expMax andExpMin:expMin andSecs:secs];
    
    
  NSArray * arrMM =   [self cross0:Dmin andMax:Dmax andNewMin:[[expMin valueForKey:@"c"] doubleValue] andNewMax:[[expMax valueForKey:@"c"] doubleValue]];
    
    double minC = [[arrMM objectAtIndex:0] doubleValue];
    double maxC = [[arrMM objectAtIndex:1] doubleValue];
    
  
    
    if ([SmartSteps singleton].minLocked || [SmartSteps singleton].maxLocked) {
       NSDictionary* dic =   [self singleLocked:Dmin andMax:Dmax andExpMin:expMin andExpMax:expMax];
        minC = [[dic valueForKey:@"emin"] doubleValue];
        maxC = [[dic valueForKey:@"emax"] doubleValue];
    }
    

    return [self makResult:[NSString stringWithFormat:@"%f",minC] andMax:[NSString stringWithFormat:@"%f",maxC] andSec:secs andExpon:[[expMax valueForKey:@"e"] intValue]];
}
+(NSDictionary*) singleLocked:(double) min andMax:(double) max andExpMin:(NSDictionary*) eMin andExpMax:(NSDictionary*) eMax
{
    double emax = 0.0;
    double emin = 0.0;
    if ([SmartSteps singleton].minLocked) {
        
        NSDictionary * expMin = [self expNum:[NSString stringWithFormat:@"%f",min] digit:@"4" byFloor:1];
        
        if ([[eMin valueForKey:@"e"] intValue]-[[expMin valueForKey:@"e"] intValue] > 6) {
            expMin = @{@"c": [NSNumber numberWithInt:0],@"e":[eMin valueForKey:@"e"]};
        }
        
        eMin = [self expFixMin:eMin :expMin :0];
        eMax = [self expFixMin:eMax :eMin :0];
        
        emax += [[expMin valueForKey:@"c"] doubleValue]-[[eMin valueForKey:@"c"] doubleValue];
        emin  = [[expMin valueForKey:@"c"] doubleValue];
        
    }else if ([SmartSteps singleton].maxLocked)
    {
        NSDictionary * expMax = [self expNum:[NSString stringWithFormat:@"%f",max] digit:@"4" byFloor:0];
        if ([[eMax valueForKey:@"e"] intValue] - [[expMax valueForKey:@"e"] intValue] >6) {
            expMax = @{@"c": [NSNumber numberWithInt:0],@"e":[eMax valueForKey:@"e"]};
            
        }
        eMin = [self expFixMin:eMin :expMax :0];
        eMax = [self expFixMin:eMax :expMax :0];
        
        emin += [[expMax valueForKey:@"c"] doubleValue]-[[eMax valueForKey:@"c"] doubleValue];
        emax = [[expMax valueForKey:@"c"] doubleValue];
    }
    
    return @{@"emin": [NSNumber numberWithDouble:emin],@"emax":[NSNumber numberWithDouble:emax]};
}

+(NSDictionary*) expFixMin:(NSDictionary*) expnum1 :(NSDictionary*) expnum2 : (int)_byFloor
{
    int  number1E = [[expnum1 valueForKey:@"e"] intValue];
    int  number2E = [[expnum2 valueForKey:@"e"] intValue];
    
    NSDictionary* returnDic = nil;
    
    if (number1E<number2E) {
        returnDic = [self expFixTo:expnum2 :expnum1 :_byFloor];
    }else{
        returnDic = [self expFixTo:expnum1 :expnum2 :_byFloor];
    }
    
    return returnDic;
    
}

+(int) tryForInt:(NSString*) min andMax:(NSString*) max andSection:(int) section andExpMax:(NSDictionary*) expMax andExpMin:(NSDictionary*) expMin  andSecs:(int) secs
{
    int intMax = [max intValue];
    int intMin = [min intValue];
    

    double DmaxC = [[expMax valueForKey:@"c"] doubleValue];
    double DminC = [[expMin valueForKey:@"c"] doubleValue];
    
    double span = DmaxC-DminC;
    double step = span/secs*pow(10, [[expMax valueForKey:@"e"] intValue]);
    //一定是个小数
    
    step = floor(step);
    span = step * secs;
    if (span < intMax-intMin) {
        step += 1;
        span = step* secs;
        
        if (!section && (step * (secs-1)>=(intMax-intMin))) {
            secs -=1;
            span = step* secs;
        }
    }
    /*
    if (span >= intMax-intMin) {
        double delta = span-(intMax-intMin);
        
    }
     */
    
    return secs;
    
}

+(NSDictionary*)look4step:(NSDictionary*) expMin andMax:(NSDictionary*) expMax andSecs:(int) secs
{
    double span;
    double tmpMax=0.0;
    double tmpMin;
    NSArray * stepArr = [SmartSteps singleton].custSteps ;
    tmpMin = [[expMax valueForKey:@"c"] doubleValue];
    
    double tmpStep = ([[expMax valueForKey:@"c"] doubleValue]-[[expMin valueForKey:@"c"] doubleValue])/secs -1;
    
    while (tmpMin > [[expMin valueForKey:@"c"] doubleValue]) {
       NSDictionary* tmpStepDic = [self getCeil:[NSString stringWithFormat:@"%f",tmpStep+1] andRounds:stepArr];
        double tmpStepC = [[tmpStepDic valueForKey:@"c"] doubleValue];
        int  tmpStepE  = [[tmpStepDic valueForKey:@"e"] intValue];
        
        tmpStep = tmpStepC* pow(10, tmpStepE);
        
        span = tmpStep * secs;
        tmpMax = ceil([[expMax valueForKey:@"c"] doubleValue]/tmpStep) * tmpStep;
        
        tmpMin = tmpMax-span;
    }
    double deltaMin = [[expMin valueForKey:@"c"] doubleValue]-tmpMin;
    double deltaMax = tmpMax-deltaMin;
    double deltaDelta = deltaMin-deltaMax;
    
    if (deltaDelta > tmpStep*1.1) {
        deltaDelta = round(deltaDelta/tmpStep/2) * tmpStep;
        tmpMin += deltaDelta;
        tmpMax += deltaDelta;
    }
    NSDictionary * DexpMin = @{@"c": [NSNumber numberWithInt:tmpMin],@"e":[expMin valueForKey:@"e"]};
    NSDictionary * DexpMax = @{@"c": [NSNumber numberWithInt:tmpMax],@"e":[expMax valueForKey:@"e"]};
    
 
    return @{@"step": [NSNumber numberWithDouble:tmpStep],@"expMin":DexpMin,@"expMax":DexpMax};
}

+(NSDictionary*) look4sections:(NSDictionary*) expMin andMax:(NSDictionary*) expMax
{
    int section;
    NSDictionary* tempStep;
    double DtempStep;
    double tempMin;
    double tempMax;
    
    double minC = [[expMin valueForKey:@"c"] doubleValue];
    double maxC = [[expMin valueForKey:@"c"] doubleValue];
    
    
    NSArray * custArray = [SmartSteps singleton].custSection;
    NSArray * stepArr = [SmartSteps singleton].custSteps;
    NSMutableArray * reference = [[NSMutableArray alloc] init];
    
    for (int i=custArray.count;i--;) {
        section = [[custArray objectAtIndex:i] intValue];
        tempStep = [self getCeil:[NSString stringWithFormat:@"%f",(maxC-minC)/section] andRounds:stepArr];
        int  tempStepE = [[tempStep valueForKey:@"e"] intValue];
        double  tempStepC = [[tempStep valueForKey:@"c"] doubleValue];
        DtempStep = tempStepC * pow(10, tempStepE);
        tempMin = floor(minC/DtempStep) * DtempStep;
        tempMax = ceil(maxC/DtempStep) * DtempStep;
        
        reference[i] = @{@"min": [NSNumber numberWithDouble:tempMin],@"max":[NSNumber numberWithDouble:tempMax],@"step":[NSNumber numberWithDouble:DtempStep],@"span":[NSNumber numberWithDouble:tempMax-tempMin]};
        
    }
  NSArray * referStore =   [reference sortedArrayUsingComparator:^NSComparisonResult(NSDictionary* dic1,NSDictionary * dic2){
       
        double span1 = [[dic1 valueForKey:@"span"] doubleValue];
        double span2 = [[dic2 valueForKey:@"span"] doubleValue];
        double delta = span1-span2;
        
        double step1 = [[dic1 valueForKey:@"step"] doubleValue];
        double step2 = [[dic2 valueForKey:@"step"] doubleValue];
        if (delta ==0) {
            
            delta = step1-step2;
        }
        
        return delta;
    }];
    
    NSDictionary * refDic = [referStore objectAtIndex:0];
    
    double refSpan = [[refDic valueForKey:@"span"] doubleValue];
    double refStep = [[refDic valueForKey:@"step"] doubleValue];
    
    section = refSpan/refStep;
    NSDictionary * DexpMin = @{@"c": [refDic valueForKey:@"min"],@"e":[expMin valueForKey:@"e"]};
    NSDictionary * DexpMax = @{@"c": [refDic valueForKey:@"max"],@"e":[expMax valueForKey:@"e"]};
    
    section = section<3 ? section * 2 : section;
    
    return @{@"section": [NSNumber numberWithInt:section],@"expMin":DexpMin,@"expMax":DexpMax};
    
}

+(NSDictionary*) forSpan0:(double) min andMax:(double) max andSection:(int) section
{
    section = section ? section : 5;
    double delta = MIN(fabs(max/section), section)/2.1;
    
    if ([SmartSteps singleton].minLocked) {
        max = min + delta;
    }else if ([SmartSteps singleton].maxLocked){
        min = max - delta;
    }else{
        min = min - delta;
        max = max + delta;
    }
    
    return [self coreCalc:[NSString stringWithFormat:@"%f",min] andMax:[NSString stringWithFormat:@"%f",max] andSec:section];

}

+(NSDictionary*) getCeil:(NSString*) num andRounds:(NSArray*) rounds
{
   
    
    rounds = rounds.count>0 ? rounds : [SmartSteps singleton].mySteps;
    
    NSDictionary* numDic = [self expNum:num digit:@"0" byFloor:0];
    
    int expon = [[numDic valueForKey:@"e"] intValue];
   
    
    double cNum = [[numDic valueForKey:@"c"] doubleValue];
    int i=0;
    while (cNum > [[rounds objectAtIndex:i] doubleValue]) {
        i++;
    }
    
    if (![[rounds objectAtIndex:i] intValue]) {
        cNum /=10;
        
        expon +=1;
        i=0;
        
        while (cNum > [[rounds objectAtIndex:0] doubleValue]) {
            i++;
        }
    }
    return @{@"c": [rounds objectAtIndex:i],@"e":[NSNumber numberWithInt:expon]};
    
}


@end
