//
//  UIView+DChar.m
//  DChar
//
//  Created by iMuse on 15-8-6.
//  Copyright (c) 2015年 mySelf. All rights reserved.
//

#import "UIView+DChar.h"
#import "NSObject+Dchar.h"

@implementation UIView (DChar)

-(void) drawRoundRect:(CGRect) rect
{
    CGFloat  width  = rect.size.width;
    CGFloat  height = rect.size.height;
    
 
    //起点坐标
    CGFloat  originX = rect.origin.x+left;
    CGFloat  originY = rect.origin.y+top;
    
    CGFloat  rectWidth = width-2*left;
    CGFloat  rectHeight= height-2*top+40;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat radius = 5;
    
    CGContextSetRGBStrokeColor(context,220/255.0,220/255.0,220/255.0,1.0);
     CGContextSetFillColorWithColor(context, [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1.0].CGColor);
    
    CGContextMoveToPoint(context, originX+radius, originY);
    //第一条线和第一个圆弧
    CGContextAddLineToPoint(context, rectWidth-radius, originY);
    CGContextAddArc(context, rectWidth-radius, originY+radius, radius,-0.5* M_PI,0.0, 0);
    
    CGContextAddLineToPoint(context, rectWidth,originY+rectHeight-radius);
    CGContextAddArc(context,rectWidth-radius,originY+rectHeight-radius, radius,0.0,0.5*M_PI, 0);
    
    CGContextAddLineToPoint(context, originX+radius, originY+rectHeight);
    CGContextAddArc(context, originX+radius, originY+rectHeight-radius, radius, 0.5*M_PI,M_PI, 0);
    
    CGContextAddLineToPoint(context, originX, originY+radius);
    CGContextAddArc(context, originX+radius, originY+radius, radius, M_PI, 1.5*M_PI, 0);
   
    CGContextSetLineWidth(context, 1.0);

    CGContextDrawPath(context, kCGPathFillStroke);
    [self drawTitle];
    [self drawAxis_Y:rect];
    [self drawAxis_X:rect];
    
}


-(void)drawTitle
{
    NSMutableDictionary *titleDic = [NSMutableDictionary dictionary];
    
    titleDic[NSForegroundColorAttributeName] =[self color:@"44,120,191,1"];
    titleDic[NSFontAttributeName] = [UIFont systemFontOfSize:20];
    
    NSMutableDictionary *subTitleDic = [NSMutableDictionary dictionary];
    subTitleDic[NSForegroundColorAttributeName] = [self color:@"184,184,184,1"];
    subTitleDic[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    
    NSString * titleString = @"未来一周天气情况";
    [titleString drawAtPoint:CGPointMake(left_padding, top_padding) withAttributes:titleDic];
    
    NSString * subTitleString = @"纯属虚构";
    [subTitleString drawAtPoint:CGPointMake(left_padding, top_padding+30) withAttributes:subTitleDic];
}




-(void)drawAxis_Y:(CGRect) rect
{
    
    CGFloat axisHeight = [self getAxis_Height:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,43/255.0,120/255.0,191/255.0,1.0);
    CGContextSetLineWidth(context, 1.5);
    CGContextMoveToPoint(context, AXIS_X, AXIS_Y);
    CGContextAddLineToPoint(context, AXIS_X, AXIS_Y+axisHeight);
    CGContextDrawPath(context, kCGPathFillStroke);
    

}
-(void)drawAxis_X:(CGRect) rect
{
    CGFloat axisWidth = [self getAxis_Width:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetRGBStrokeColor(context,43/255.0,120/255.0,191/255.0,1.0);
    CGContextSetLineWidth(context, 1.5);
    CGContextMoveToPoint(context, AXIS_X, AXIS_Y+[self getAxis_Height:rect]);
    CGContextAddLineToPoint(context, AXIS_X+axisWidth, AXIS_Y+[self getAxis_Height:rect]);
    CGContextDrawPath(context, kCGPathFillStroke);
    
}
-(void) drawAxisLineY:(CGRect) rect andArray:(NSArray*) array
{
    NSNumber* maxNumber =    [array valueForKeyPath:@"@max.floatValue"];
    NSNumber* minNumber =    [array valueForKeyPath:@"@min.floatValue"];
  
   NSDictionary* dic =  [self axisyList:[NSString stringWithFormat:@"%@",minNumber] andMax:[NSString stringWithFormat:@"%@",maxNumber]];
    
    
  
}
//绘制平均值
-(CGMutablePathRef) avgPath
{
    CGMutablePathRef path = CGPathCreateMutable();
   // CGPathMoveToPoint(path, NULL, AXIS_X, <#CGFloat y#>)
    /*
     CAShapeLayer *shapeLayer = [CAShapeLayer layer];
     
     [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
     [shapeLayer setStrokeColor:[[UIColor blackColor] CGColor]];
     [shapeLayer setLineWidth:3.0f];
     [shapeLayer setLineJoin:kCALineJoinRound];
     [shapeLayer setLineDashPattern:
     [NSArray arrayWithObjects:[NSNumber numberWithInt:10],
     [NSNumber numberWithInt:5],nil]];
     
     
     CGMutablePathRef path = CGPathCreateMutable();
     CGPathMoveToPoint(path, NULL, 10, 10);
     CGPathAddLineToPoint(path, NULL, 100,100);
     
     [shapeLayer setPath:path];
     CGPathRelease(path);
     
     [[self layer] addSublayer:shapeLayer];
     */
    return path;
}



-(CGFloat)pointX:(CGRect) rect andCount: (NSInteger) count andLocation:(NSInteger) location
{
    
  return  AXIS_X+([self getAxis_Width:rect]/(count-1))*location;
    
}
-(CGFloat)pointY:(CGRect) rect andNumber:(NSInteger) number andMaxNumber:(NSInteger)maxNumber
{
   
    return AXIS_Y+[self getAxis_Height:rect]-([self getAxis_Height:rect]/maxNumber*number);
}


-(CAKeyframeAnimation*)Animation:(CGPathRef) thPath
{
    CAKeyframeAnimation * cakeyAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    cakeyAnimation.path = thPath;
    cakeyAnimation.duration = 2;
    
    
    return cakeyAnimation;
}

-(UIColor*) color:(NSString*)colorString
{
    if([colorString isEqualToString:@"clear"])
    {
        return [UIColor clearColor];
    }
    
    NSArray* colors = [colorString componentsSeparatedByString:@","];
    
    if([colors count]!=3 && [colors count]!=4)
    {
        colors = [DefaultCellBackgroundColor componentsSeparatedByString:@","];
    }
    
    float red   = [(NSString*)[colors objectAtIndex:0] floatValue];
    float green = [(NSString*)[colors objectAtIndex:1] floatValue];
    float blue  = [(NSString*)[colors objectAtIndex:2] floatValue];
    float alpha = 1;
    
    if([colors count]==4)
    {
        alpha = [(NSString*)[colors objectAtIndex:3] floatValue];
    }
    
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha];
}

-(CGFloat)getAxis_Width:(CGRect) rect
{
    return  rect.size.width-2*left-(AXIS_X*2);
}
-(CGFloat)getAxis_Height:(CGRect) rect
{
    return  (rect.size.height-2*top+40)*2/3;
}


@end
