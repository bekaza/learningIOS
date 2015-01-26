//
//  BNRItemsViewController.m
//  Homepwner
//
//  Created by manit on 24/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRItemsViewController.h"
#import "BNRItemStore.h"
#import "BNRitem.h"

@implementation BNRItemsViewController

- (instancetype)init
{
    
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        [self.tableView setContentInset:UIEdgeInsetsMake(20, 0, 0, 0)];
        for (int i = 0; i < 5; i++) {
            [[BNRItemStore sharedStore] createItem];
        }
        //[[BNRItemStore sharedStore] addLastObj];
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Value Worst";
    else
        return @"Value Rest";
}

- (NSInteger)tableView:(UITableView *)tableView
            numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"ItemWorst -- > %d" , [[[BNRItemStore sharedStore] allItemsWorst] count]);
    //return [[[BNRItemStore sharedStore] allItems] count];
    
    if (section == 0) {
        return [[[BNRItemStore sharedStore] allItemsWorst] count];
    }else{
        return [[[BNRItemStore sharedStore] allItemsRest] count] + 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new or recycled cell
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                    forIndexPath:indexPath];
    // Set the text on the cell with the description of the item
    // that is at the nth index of items, where n = row this cell
    // will appear in on the tableview
    //NSLog(@"indexPath Section --> %d",indexPath.section);
    NSArray * items;
    NSInteger lastrow = 0;
    if(indexPath.section == 0){
        items = [[BNRItemStore sharedStore] allItemsWorst];
    }else{
        items = [[BNRItemStore sharedStore] allItemsRest];
        lastrow = items.count;
    }
    
    if (indexPath.section != 0 && lastrow == indexPath.row && lastrow != 0) {
        cell.textLabel.text = @"No more item!";
    }else{
        BNRitem * item = items[indexPath.row];
        cell.textLabel.text = [item description];
    }
    
    return cell;
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
}
@end
