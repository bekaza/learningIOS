//
//  BNRImageTransformer.m
//  Homepwner
//
//  Created by manit on 7/2/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRImageTransformer.h"

@implementation BNRImageTransformer

+(Class)transformedValueClass
{
    return [NSData class];
}

-(id)transformedValue:(id)value
{
    if (!value) {
        return nil;
    }
    
    if ([value isKindOfClass:[NSData class]]) {
        return value;
    }
    
    return UIImagePNGRepresentation(value);
}

-(id)reverseTransformedValue:(id)value
{
    return [UIImage imageWithData:value];
}

@end
