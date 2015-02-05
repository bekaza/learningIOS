//
//  BNRHypnosisView.m
//  Hypnosister
//
//  Created by manit on 13/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRHypnosisView.h"

@interface BNRHypnosisView()

@property (strong, nonatomic) UIColor * circleColor;

@end

@implementation BNRHypnosisView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.circleColor = [UIColor lightGrayColor];
    }
    return self;
}

- (void)setCircleColor:(UIColor *)circleColor
{
    _circleColor = circleColor;
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
*/
- (void)drawRect:(CGRect)rect
{
    CGRect bounds = self.bounds;
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Figure out the center of the bounds rectangle
    CGPoint center;
    center.x = bounds.origin.x + bounds.size.width / 2.0;
    center.y = bounds.origin.y + bounds.size.height / 2.0;
    
    //img Bignerd
    CGRect imgRect = rect;
    
    //set Bound for img
    imgRect.origin.x = rect.size.width / 4.0;
    imgRect.origin.y = rect.size.height / 4.0;
    imgRect.size.width = rect.size.width / 2.0;
    imgRect.size.height = rect.size.height / 2.0;
    
    // The largest circle will circumscribe the view
    float maxRadius = (hypot(bounds.size.width, bounds.size.height) / 2.0);
    
    UIBezierPath *path = [[UIBezierPath alloc] init];
    
    for (float currentRadius = maxRadius; currentRadius > 0; currentRadius -= 20) {
        
        [path moveToPoint:CGPointMake(center.x + currentRadius, center.y)];
        
        [path addArcWithCenter:center
                        radius:currentRadius // Note this is currentRadius!
                    startAngle:0.0
                      endAngle:M_PI * 2.0
                     clockwise:YES];
    }
    
    path.lineWidth = 10;
    
    [self.circleColor setStroke];
    // Draw the line!
    [path stroke];
    
    CGContextSaveGState(context);
    
    //Draw triangle
    CGPoint Tri_Point1 = CGPointMake(center.x, imgRect.origin.y);
    CGPoint Tri_Point2 = CGPointMake(imgRect.origin.x, imgRect.origin.y + imgRect.size.height);
    
    CGPoint Tri_Point3 = CGPointMake(imgRect.origin.x + imgRect.size.width, imgRect.origin.y + imgRect.size.height);
    
    UIBezierPath *triangle = [UIBezierPath bezierPath];
    [triangle moveToPoint:Tri_Point1];
    [triangle addLineToPoint:Tri_Point2];
    [triangle addLineToPoint:Tri_Point3];
    [triangle closePath];
    
    [triangle addClip];
    
    //Draw Gradient
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { 1.0, 0.0, 0.0, 1.0,   // Start color is red
        1.0, 1.0, 0.0, 1.0 }; // End color is yellow
    
    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorspace, components,locations, 2);
    
    CGPoint startPoint = CGPointMake(center.x, imgRect.origin.y);
    CGPoint endPoint = CGPointMake(center.x, imgRect.origin.y + imgRect.size.height);
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorspace);
    
    
    
    CGContextRestoreGState(context);
    
    
    
    //load img
    UIImage *logoImage = [UIImage imageNamed:@"logo.png"];
    
    
    CGContextSaveGState(context);
    
    CGContextSetShadow(context, CGSizeMake(4,7), 3);
    // Draw stuff here, it will appear with a shadow
    [logoImage drawInRect:imgRect];
    
    CGContextRestoreGState(context);
    
    // Draw stuff here, it will appear with no shadow
    
}

// When a finger touches the screen
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    NSLog(@"%@ was touched", self);
    
    // Get 3 random numbers between 0 and 1
    float red = (arc4random() % 100) / 100.0;
    float green = (arc4random() % 100) / 100.0;
    float blue = (arc4random() % 100) / 100.0;
    
    UIColor *randomColor = [UIColor colorWithRed:red
                                           green:green
                                            blue:blue
                                           alpha:1.0];
    
    self.circleColor = randomColor;
}


@end
