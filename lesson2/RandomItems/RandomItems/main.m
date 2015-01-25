//
//  main.m
//  RandomItems
//
//  Created by manit on 24/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BNRitem.h"

int main(int argc, const char * argv[])
{

    @autoreleasepool {
    
        NSMutableArray *items = [[NSMutableArray alloc] init];
        BNRitem *backpack = [[BNRitem alloc] initWithItemName:@"Backpack"];
        [items addObject:backpack];
        
        BNRitem *calculator = [[BNRitem alloc] initWithItemName:@"Calculator"];
        [items addObject:calculator];
        
        backpack.containedItem = calculator;
        
        backpack = nil;
        calculator = nil;
        
        for (BNRitem *item in items)
            NSLog(@"%@", item);
        
        NSLog(@"Setting items to nil...");
        items = nil;
        
        
    }
    return 0;
}

