//
//  BNRDateViewController.m
//  Homepwner
//
//  Created by manit on 29/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRDateViewController.h"
#import "BNRDetailViewController.h"
#import "BNRitem.h"

@interface BNRDateViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePick;

@end

@implementation BNRDateViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    NSLog(@"%@", self.item.description);
    [_datePick setDate:self.item.dateCreated animated:YES];
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    self.item.dateCreated = _datePick.date;
}

@end
