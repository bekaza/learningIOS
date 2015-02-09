//
//  BNRItemStore.m
//  Homepwner
//
//  Created by manit on 24/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//
#import "BNRAppDelegate.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
#include "BNRImageStore.h"

@interface BNRItemStore ()

@property (nonatomic) NSMutableArray * privateItems;
@property (nonatomic, strong) NSMutableArray * allAssetTypes;
@property (nonatomic, strong) NSManagedObjectContext * context;
@property (nonatomic, strong) NSManagedObjectModel * model;

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
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        NSPersistentStoreCoordinator * psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        NSString * path = self.itemArchivePath;
        NSURL * stroeURL = [NSURL fileURLWithPath:path];
        
        NSError * error = nil;
        
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType
                               configuration:nil
                                         URL:stroeURL
                                     options:nil
                                       error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure" reason:[error localizedDescription] userInfo:nil];
        }
        
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = psc;
        
        [self loadAllItems];
    }
    return self;
}

- (NSArray *)allItems
{
    return self.privateItems;
}

- (BNRItem *)createItem
{
    double order;
    if ([self.allItems count] == 0) {
        order = 1.0;
    }else{
        order = [[self.privateItems lastObject] orderingValue] + 1.0;
    }
    NSLog(@"Adding after %lu items, order = %.2f", (unsigned long)[self.privateItems count], order);
    
    BNRItem * item = [NSEntityDescription insertNewObjectForEntityForName:@"BNRItem"
                                                   inManagedObjectContext:self.context];
    
    item.orderingValue = order;
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    item.valueDollars = [defaults integerForKey:BNRNextItemValuePrefsKey];
    item.itemName = [defaults objectForKey:BNRNextItemNamePrefsKey];
    
    NSLog(@"defaults = %@", [defaults dictionaryRepresentation]);
    
    [self.privateItems addObject:item];
    
    return item;
}

-(void)removeItem:(BNRItem *)item
{
    NSString * key = item.itemKey;
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

-(void)moveItemAtIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    //Get pointer to object being moved so you can re-insert it
    BNRItem * item = self.privateItems[fromIndex];
    
    //Remove item from array
    [self.privateItems removeObjectAtIndex:fromIndex];
    
    //Insert item in array at new location
    [self.privateItems insertObject:item atIndex:toIndex];
    
    double lowerBound = 0.0;
    
    if (toIndex > 0) {
        lowerBound = [self.privateItems[(toIndex-1)] orderingValue];
    }else{
        lowerBound = [self.privateItems[1] orderingValue] - 2.0;
    }
    
    double upperBound = 0.0;
    
    if (toIndex < [self.privateItems count] -1) {
        upperBound = [self.privateItems[(toIndex + 1)] orderingValue];
    }else{
        upperBound = [self.privateItems[(toIndex - 1)] orderingValue] + 2.0;
    }
    
    double newOrderValue = (lowerBound + upperBound) / 2.0;
    
    NSLog(@"moving to order %f", newOrderValue);
    item.orderingValue = newOrderValue;
}

-(NSString *)itemArchivePath
{
    // Make sure that the first argument is NSDocumentDirectory
    // and not NSDocumentationDirectory
    NSArray * documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                                        NSUserDomainMask, YES);
    
    // Get the one document directory from that list
    NSString * documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}

-(BOOL)saveChanges
{
    NSError * error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saveing: %@", [error localizedDescription]);
    }
    return successful;
}

-(void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        NSEntityDescription * e = [NSEntityDescription entityForName:@"BNRItem"
                                              inManagedObjectContext:self.context];
        request.entity = e;
        
        NSSortDescriptor * sd = [NSSortDescriptor sortDescriptorWithKey:@"orderingValue" ascending:YES];
        request.sortDescriptors = @[sd];
        
        NSError * error;
        NSArray * result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
    }
}

-(NSArray *)allAssetTypes
{
    if (!_allAssetTypes) {
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription * e = [NSEntityDescription entityForName:@"BNRAssetType"
                                              inManagedObjectContext:self.context];
        request.entity = e;
        
        NSError * error = nil;
        NSArray * result = [self.context executeFetchRequest:request error:&error];
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        _allAssetTypes = [result mutableCopy];
    }
    
    if ([_allAssetTypes count] == 0) {
        NSManagedObject * type;
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Furniture" forKey:@"Label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Jewelry" forKey:@"Label"];
        [_allAssetTypes addObject:type];
        
        type = [NSEntityDescription insertNewObjectForEntityForName:@"BNRAssetType"
                                             inManagedObjectContext:self.context];
        [type setValue:@"Electronic" forKey:@"Label"];
        [_allAssetTypes addObject:type];
        
    }
    return _allAssetTypes;
}
@end
