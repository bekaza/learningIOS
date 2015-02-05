//
//  BNRItemStore.h
//  Homepwner
//
//  Created by manit on 24/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BNRitem;
@interface BNRItemStore : NSObject

@property (nonatomic, readonly) NSArray *allItems;
// Notice that this is a class method and prefixed with a + instead of a -
+ (instancetype)sharedStore;
- (BNRitem *)createItem;
-(void)removeItem:(BNRitem *)item;
-(void)moveItemAtIndex:(NSUInteger)fromIndex
               toIndex:(NSUInteger)toIndex;
-(BOOL)saveChanges;
@end
