//
//  BNRitem.h
//  RandomItems
//
//  Created by manit on 24/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BNRitem : NSObject

@property (nonatomic, strong) BNRitem *containedItem;
@property (nonatomic, weak) BNRitem *container;

@property (nonatomic, copy) NSString *itemName;
@property (nonatomic, copy) NSString *serialNumber;
@property (nonatomic) int valueInDollars;
@property (nonatomic, readonly, strong) NSDate *dateCreated;

// Designated initializer for BNRItem
- (instancetype)initWithItemName:(NSString *)name valueInDollars:(int)value serialNumber:(NSString *)sNumber;
- (instancetype)initWithVodka;
- (instancetype)initWithItemName:(NSString *)name;
+ (instancetype)randomItem;

@end