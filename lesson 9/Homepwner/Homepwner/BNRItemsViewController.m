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

@interface BNRItemsViewController()

//strong property beacuase a top-level object in the XIB file
@property (nonatomic, strong)IBOutlet UIView * headerView;

@end

@implementation BNRItemsViewController

-(UIView *)headerView
{
    //if you have not loaded the header view yet ...
    if (!_headerView) {
        //Load HeaderView.xib
        [[NSBundle mainBundle] loadNibNamed:@"HeaderView" owner:self options:nil];
    }
    return _headerView;
}

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {

    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}
- (NSInteger)tableView:(UITableView *)tableView
            numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count] + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new or recycled cell
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                    forIndexPath:indexPath];
    if ([[[BNRItemStore sharedStore] allItems] count] != 0) {
        NSArray *items = [[BNRItemStore sharedStore] allItems];
        BNRitem *item = items[indexPath.row];
        cell.textLabel.text = [item description];
        return cell;
    }else{
        cell.textLabel.textColor = [UIColor redColor];
        cell.textLabel.text = @"No More Item !!!";
        //cell.textLabel.textAlignment = NSTextAlignmentCenter;
        return cell;
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView * header = self.headerView;
    [self.tableView setTableHeaderView:header];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"UITableViewCell"];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.y += 20;
    frame.size.height -= 20;
    [self.tableView setFrame:frame];
}

//other method Here

-(IBAction)addNewItem:(id)sender
{
    //Create a new BNRitem and add it to the store
    BNRitem * newItem = [[BNRItemStore sharedStore] createItem];
    
    //Figure out where that item is in the array
    NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    NSIndexPath * indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    //Insert this new row into the table.
    [self.tableView insertRowsAtIndexPaths:@[indexPath]
                          withRowAnimation:UITableViewRowAnimationTop];
}

-(IBAction)toggleEditingMode:(id)sender
{
    //if you are currently in editing mode ...
    if (self.isEditing) {
        
        //Change text of button to inform user of state
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        
        //Turn off editing mode
        [self setEditing:NO animated:YES];
    }else{
        
        //change text of button to inform user of state
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        
        //Enter editing mode
        [self setEditing:YES animated:YES];
    }
}

-(void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //If the table view is asking to commit a delete command...
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray * items = [[BNRItemStore sharedStore] allItems];
        BNRitem * item = items[indexPath.row];
        [[BNRItemStore sharedStore] removeItem:item];
        
        //Also remove that row from the table view with an animation
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

-(void)tableView:(UITableView *)tableView
moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
     toIndexPath:(NSIndexPath *)destinationIndexPath
{
    
    NSInteger dest = destinationIndexPath.row;
    if (dest == [[[BNRItemStore sharedStore] allItems] count]) {
        dest--;
    }
    [[BNRItemStore sharedStore]
     moveItemAtIndex:sourceIndexPath.row
     toIndex:dest];
}

-(NSIndexPath *)tableView:(UITableView *)tableView targetIndexPathForMoveFromRowAtIndexPath:(NSIndexPath *)sourceIndexPath toProposedIndexPath:(NSIndexPath *)proposedDestinationIndexPath
{
    if(proposedDestinationIndexPath.row == [[[BNRItemStore sharedStore] allItems] count]){
        NSIndexPath * destIndexPath = [NSIndexPath indexPathForRow:proposedDestinationIndexPath.row-1 inSection:0];
        return destIndexPath;
    }else{
        return proposedDestinationIndexPath;
    }
}

-(NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == [[[BNRItemStore sharedStore] allItems] count]) {
        return NO;
    }else{
        return YES;
    }
}

@end
