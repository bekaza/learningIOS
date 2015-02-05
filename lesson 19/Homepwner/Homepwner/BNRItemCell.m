//
//  BNRItemCell.m
//  Homepwner
//
//  Created by manit on 4/2/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRItemCell.h"

@implementation BNRItemCell

-(IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

@end
