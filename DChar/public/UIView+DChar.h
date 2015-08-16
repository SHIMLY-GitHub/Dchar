//
//  UIView+DChar.h
//  DChar
//
//  Created by iMuse on 15-8-6.
//  Copyright (c) 2015年 mySelf. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DChar)


-(void) drawRoundRect:(CGRect) rect;
-(CGFloat)getAxis_Width:(CGRect) rect;
-(CGFloat)getAxis_Height:(CGRect) rect;
-(CAKeyframeAnimation*)Animation:(CGPathRef) thPath;
-(CGFloat)pointY:(CGRect) rect andNumber:(NSInteger) number andMaxNumber:(NSInteger)maxNumber;
-(CGFloat)pointX:(CGRect) rect andCount: (NSInteger) count andLocation:(NSInteger) location;

-(void) drawAxisLineY:(CGRect) rect andArray:(NSArray*) array;


@end
