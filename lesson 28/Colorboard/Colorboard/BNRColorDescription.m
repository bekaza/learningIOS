//
//  BNRColorDescription.m
//  Colorboard
//
//  Created by manit on 10/2/2558.
//  Copyright (c) พ.ศ. 2558 BIg Nerd Ranch. All rights reserved.
//

#import "BNRColorDescription.h"

@implementation BNRColorDescription

-(instancetype)init
{
    self = [super init];
    if (self) {
        _color = [UIColor colorWithRed:0 green:0 blue:1 alpha:1];
        _name = @"Blue";
    }
    return self;
}
@end
