//
//  BNRItemStore.m
//  Homepwner
//
//  Created by manit on 24/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRItemStore.h"
#import "BNRitem.h"
@interface BNRItemStore ()

@property (nonatomic) NSMutableArray * privateItems;

@end

@implementation BNRItemStore

+ (instancetype)sharedStore
{
    static BNRItemStore *sharedStore = nil;
    
    // Do I need to create a sharedStore?
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}

- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton"
                                   reason:@"Use +[BNRItemStore sharedStore]"
                                 userInfo:nil];
    return nil;
}
        
// Here is the real (secret) initializer
- (instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _privateItems = [[NSMutableArray alloc] init];
    }
    return self;
}
- (NSArray *)allItems
{
    return self.privateItems;
}
- (BNRitem *)createItem
{
    BNRitem *item = [BNRitem randomItem];
    
    [self.privateItems addObject:item];
    
    return item;
}
@end
