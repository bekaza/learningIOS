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

@property (nonatomic, readonly) NSArray *allItemsWorst;
@property (nonatomic, readonly) NSArray *allItemsRest;
// Notice that this is a class method and prefixed with a + instead of a -
+ (instancetype)sharedStore;
- (BNRitem *)createItem;
- (BNRitem *)addLastObj;
@end
