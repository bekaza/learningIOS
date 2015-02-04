//
//  BNRLine.m
//  TouchTracker
//
//  Created by manit on 30/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRLine.h"

@implementation BNRLine

-(UIColor *)lineColor
{
    CGFloat dimY = self.end.y - self.begin.y;
    CGFloat dimX = self.end.x - self.begin.x;
    
    //NSLog(@"dimY = %f - %f ", self.end.y, self.begin.y);
    //NSLog(@"dimX = %f - %f ", self.end.x, self.begin.x);
    
    CGFloat angle = atan2f(dimX, dimY);
    //NSLog(@"angle(%f) = %f , %f ",angle , dimX, dimY);
    
    CGFloat cValue=(angle+M_PI)/(M_PI*2);
    //NSLog(@"cValue(%f) = %f , %f ",angle , dimX, dimY);
    UIColor * color = [UIColor colorWithHue:cValue
                                 saturation:1.0
                                 brightness:1.0
                                      alpha:1.0];
    return color;
}

@end
