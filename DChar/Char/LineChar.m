//
//  LineChar.m
//  DChar
//
//  Created by iMuse on 15-8-6.
//  Copyright (c) 2015年 mySelf. All rights reserved.
//

#import "LineChar.h"
#import "UIView+DChar.h"
#import "SmartSteps.h"
@implementation LineChar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
       
    }
    return self;
}


- (void)drawRect:(CGRect)rect
{
   

  
    [self drawRoundRect:rect];
    
    NSArray * arrayDate = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
    NSArray * array = @[@"11",@"11",@"13",@"13",@"12",@"13",@"10"];
    
    [self drawAxisLineY:rect andArray:array];
    
   // [self drawAxis_PointX:rect andArray:arrayDate];
   // [self drawAxis_PointY:rect andArray:nil];
    //[self drawQuadCurvePath:[self getPointArray:rect andArray:array]];
    
}



-(void) drawAxis_PointY:(CGRect)rect andArray:(NSArray*) _array
{
    /* NSNumber* maxNumber =    [_array valueForKeyPath:@"@max.floatValue"];
     NSNumber* minNumber =    [_array valueForKey:@"@min.floatValue"];
     NSNumber *avgNumber =   [_array valueForKeyPath:@"@avg.floatValue"];
     
     NSInteger maxInteger = [maxNumber integerValue];
     NSInteger minInteger = [minNumber integerValue];
     NSInteger avgInteger = [avgNumber integerValue];
     
     NSInteger spaceInteger = 0;
     */
    
    // ((AXIS_Y)+[self getAxis_Height:rect])-([self getAxis_Height:rect]/array.count)*index

    
    NSMutableDictionary *Axis_YDic = [NSMutableDictionary dictionary];
    
    Axis_YDic[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    NSArray * array = @[@"0",@"3",@"6",@"9",@"12",@"15"];
    
    for (NSInteger index=0; index<array.count; index++) {
        NSString * string = [array objectAtIndex:index];
        
        [string drawAtPoint:CGPointMake(AXIS_X-20, ((AXIS_Y)+[self getAxis_Height:rect])-([self getAxis_Height:rect]/5)*index) withAttributes:Axis_YDic];
    }
    
}
-(void)drawAxis_PointX:(CGRect) rect andArray:(NSArray*) array
{
    NSMutableDictionary *Axis_XDic = [NSMutableDictionary dictionary];
    
    Axis_XDic[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    
    for (NSInteger index=0; index<array.count; index++) {
        NSString * string = [array objectAtIndex:index];
        [string drawAtPoint:CGPointMake(AXIS_X+([self getAxis_Width:rect]/(array.count-1))*index, AXIS_Y+[self getAxis_Height:rect]+20) withAttributes:Axis_XDic];
       //[string drawAtPoint:CGPointMake([self pointX:rect andCount:array.count andLocation:index], [self pointY:re andNumber:<#(NSInteger)#> andMaxNumber:<#(NSInteger)#>]) withAttributes:Axis_XDic];
    }
}
/*

-(void)drawQuadCurve:(NSMutableArray*)array
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    
    CGContextSetRGBStrokeColor(context, 44/255.0f, 120/255.0f, 191/255.0f, 1.0f);
    CGContextMoveToPoint(context, [[array objectAtIndex:0] CGPointValue].x,[[array objectAtIndex:0] CGPointValue].y);
    CGContextSetLineWidth(context, 2.0f);
    for (NSInteger index = 1; index<array.count; index++) {
        
        CGFloat pointX = [[array objectAtIndex:index] CGPointValue].x;
        CGFloat pointY = [[array objectAtIndex:index] CGPointValue].y;
        
        NSInteger nextNumber = index+1;
        if (index==(array.count-1)) {
            nextNumber =(array.count-1);
            
        }
        CGFloat next_PointX = [[array objectAtIndex:nextNumber] CGPointValue].x;
        CGFloat next_PointY = [[array objectAtIndex:nextNumber] CGPointValue].y;
        
        CGContextAddQuadCurveToPoint(context,pointX, pointY,next_PointX,next_PointY);
    }
    
    CGContextStrokePath(context);
    
    
    
}
*/
-(void) drawQuadCurvePath:(NSMutableArray*) array
{
    CGMutablePathRef thePath = CGPathCreateMutable();
    CGPathMoveToPoint(thePath, NULL,[[array objectAtIndex:0] CGPointValue].x,[[array objectAtIndex:0] CGPointValue].y);
    
    
    
    for (NSInteger index = 1; index<array.count; index++) {
        
        CGFloat pointX = [[array objectAtIndex:index] CGPointValue].x;
        CGFloat pointY = [[array objectAtIndex:index] CGPointValue].y;
        
        NSInteger nextNumber = index+1;
        if (index==(array.count-1)) {
            nextNumber =(array.count-1);
            
        }
        CGFloat next_PointX = [[array objectAtIndex:nextNumber] CGPointValue].x;
        CGFloat next_PointY = [[array objectAtIndex:nextNumber] CGPointValue].y;
        CGPathAddQuadCurveToPoint(thePath, NULL, pointX, pointY, next_PointX, next_PointY);
    }
    
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.strokeColor = [UIColor redColor].CGColor;
    shapeLayer.fillColor = [UIColor clearColor].CGColor;
    shapeLayer.lineWidth = 5;
    shapeLayer.lineJoin = kCALineJoinRound;
    shapeLayer.lineCap = kCALineCapRound;
    shapeLayer.path = thePath;
    
    [shapeLayer addAnimation:[self Animation:thePath] forKey:nil];
    [self.layer addSublayer:shapeLayer];
    
    
   
}


-(NSMutableArray*)getPointArray:(CGRect)rect andArray:(NSArray*) array
{
    NSNumber * avgNumber = [array valueForKeyPath:@"@avg.floatValue"];
    NSNumber * maxNumber = [array valueForKeyPath:@"@max.floatValue"];
  
    
    NSMutableArray * pointArray = [[NSMutableArray alloc] init];
    
    
    for (NSInteger i=0; i<array.count; i++) {
        NSInteger indexs = [[array objectAtIndex:i] intValue];
        
        CGFloat     x = [self pointX:rect andCount:array.count andLocation:i];
        
        CGFloat     y = [self pointY:rect andNumber:indexs andMaxNumber:[maxNumber integerValue]];
        [pointArray addObject:[NSValue valueWithCGPoint:CGPointMake(x, y)]];
        
    }
    return pointArray;
}


@end
