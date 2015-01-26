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

@property (nonatomic) NSMutableArray * itemWorst;
@property (nonatomic) NSMutableArray * itemRest;

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
        _itemWorst = [[NSMutableArray alloc] init];
        _itemRest = [[NSMutableArray alloc] init];
    }
    return self;
}

- (NSArray *)allItemsWorst
{
    return self.itemWorst;
}

- (NSArray *)allItemsRest
{
    return self.itemRest;
}

- (BNRitem *)createItem
{
    BNRitem *item = [BNRitem randomItem];
    
    if (item.valueInDollars > 50) {
        [self.itemWorst addObject:item];
    }else{
        [self.itemRest addObject:item];
    }
    
    return item;
}

- (BNRitem *)addLastObj
{
    [self.itemRest addObject:@"No more items!"];
    [self.itemWorst addObject:@"No more items!"];
    
    return nil;
}

@end
