//
//  BNRDetailViewController.h
//  Homepwner
//
//  Created by manit on 28/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BNRItem;

@interface BNRDetailViewController : UIViewController

-(instancetype)initForNewItem:(BOOL)isNew;
@property (nonatomic, strong) BNRItem * item;
@property (nonatomic, copy) void (^dismissBlock)(void);
@end
