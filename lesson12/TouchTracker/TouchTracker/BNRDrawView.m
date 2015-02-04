//
//  BNRDrawView.m
//  TouchTracker
//
//  Created by manit on 30/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRDrawView.h"
#import "BNRLine.h"

@interface BNRDrawView()

@property (nonatomic, strong) NSMutableDictionary * lineInProgress;
@property (nonatomic, strong) NSMutableArray * finishedLine;

@end

@implementation BNRDrawView

-(instancetype)initWithFrame:(CGRect)r
{
    self = [super initWithFrame:r];
    
    if (self) {
        self.lineInProgress = [[NSMutableDictionary alloc] init];
        self.finishedLine = [[NSMutableArray alloc] init];
        self.backgroundColor = [UIColor grayColor];
        self.multipleTouchEnabled = YES;
    }
    
    return self;
}

-(void)strokeLine:(BNRLine *)line
{
    UIBezierPath *bp = [UIBezierPath bezierPath];
    bp.lineWidth = 10;
    bp.lineCapStyle = kCGLineCapRound;
    
    [bp moveToPoint:line.begin];
    [bp addLineToPoint:line.end];
    [bp stroke];
}

-(void)drawRect:(CGRect)rect
{
    // Draw finished Lines in black
    [[UIColor blackColor] set];
    for (BNRLine * line in  self.finishedLine) {
        [self strokeLine:line];
    }
    
    [[UIColor redColor] set];
    for (NSValue * key in self.lineInProgress){
        [self strokeLine:self.lineInProgress[key]];
    }
    
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch * t in touches){
        CGPoint location = [t locationInView:self];
        
        BNRLine * line = [[BNRLine alloc] init];
        line.begin = location;
        line.end = location;
        
        NSValue * key = [NSValue valueWithNonretainedObject:t];
        self.lineInProgress[key] = line;
    }
    
    [self setNeedsDisplay];
}

-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch * t in touches){
        NSValue * key = [NSValue valueWithNonretainedObject:t];
        BNRLine * line = self.lineInProgress[key];
        
        line.end = [t locationInView:self];
    }
    
    [self setNeedsDisplay];
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch * t in touches){
        NSValue * key = [NSValue valueWithNonretainedObject:t];
        BNRLine * line = self.lineInProgress[key];
        
        [self.finishedLine addObject:line];
        [self.lineInProgress removeObjectForKey:key];
    }
    
    [self setNeedsDisplay];
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Let's put in a log statement to see the order of events
    NSLog(@"%@", NSStringFromSelector(_cmd));
    
    for (UITouch * t in touches){
        NSValue * key = [NSValue valueWithNonretainedObject:t];
        [self.lineInProgress removeObjectForKey:key];
    }
}

@end
