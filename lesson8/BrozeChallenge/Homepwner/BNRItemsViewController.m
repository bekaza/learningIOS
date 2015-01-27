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
        //Set Frame
        
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

//-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    CGRect footerFrame = [tableView rectForFooterInSection:1];
//    CGRect labelFrame = CGRectMake(20, 20, footerFrame.size.width - 40, footerFrame.size.height - 40);
//    
//    UIView *footer = [[UIView alloc] initWithFrame:footerFrame];
//    UILabel *footerLabel = [[UILabel alloc] initWithFrame:labelFrame];
//    footerLabel.textColor = [UIColor blueColor];
//    footerLabel.text = @"...";
//    [footer addSubview:footerLabel];
//    return footer;
//}

- (NSInteger)tableView:(UITableView *)tableView
            numberOfRowsInSection:(NSInteger)section
{
    //NSLog(@"ItemWorst -- > %d" , [[[BNRItemStore sharedStore] allItemsWorst] count]);
    //return [[[BNRItemStore sharedStore] allItems] count];
    
    if (section == 0) {
        return [[[BNRItemStore sharedStore] allItemsWorst] count];
    }else{
        return [[[BNRItemStore sharedStore] allItemsRest] count];
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
    NSInteger lastrow = -1;
    if(indexPath.section == 0){
        items = [[BNRItemStore sharedStore] allItemsWorst];
    }else{
        items = [[BNRItemStore sharedStore] allItemsRest];
        lastrow = items.count;
    }
    //Nomore in table view
    /*if (indexPath.section != 0 && lastrow == indexPath.row && lastrow != -1) {
        cell.textLabel.text = @"No more item!";
    }else{
        BNRitem * item = items[indexPath.row];
        cell.textLabel.text = [item description];
    }*/
    
    BNRitem * item = items[indexPath.row];
    cell.textLabel.text = [item description];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
    //last row
    /*NSArray * itemsRest = [[BNRItemStore sharedStore] allItemsRest];
    NSIndexPath * lastIndex = [NSIndexPath indexPathForRow:[itemsRest count] inSection:1];
    if (indexPath.section == 1 && lastIndex.row == indexPath.row) {
        return 44;
    }else{
        return 60;
    }*/
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
    //footer text
    UITableViewCell * lastcell = [[UITableViewCell alloc]init];
    lastcell.textLabel.text = @"No more Item !";
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 20.0 ];
    lastcell.textLabel.font  = myFont;
    self.tableView.tableFooterView = lastcell;
    
    //image Background
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
    [tempImageView setFrame:self.tableView.frame];
    self.tableView.backgroundView = tempImageView;
    
}


- (void)viewDidAppear:(BOOL)animated
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    [self.tableView setFrame:CGRectMake(frame.origin.x, frame.origin.y + 20, frame.size.width, frame.size.height-20)];
}
@end
