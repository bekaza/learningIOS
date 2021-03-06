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
#import "BNRDetailViewController.h"
#import "BNRItemCell.h"
#import "BNRImageStore.h"
#import "BNRImageViewController.h"

@interface BNRItemsViewController() <UIPopoverControllerDelegate>

//strong property beacuase a top-level object in the XIB file
@property (nonatomic, strong) IBOutlet UIView * headerView;
@property (nonatomic, strong) UIPopoverController * imagePopover;
@end

@implementation BNRItemsViewController

- (instancetype)init
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStylePlain];
    
    if (self) {
        UINavigationItem * navItem = self.navigationItem;
        navItem.title = @"Homepwner";
        
        // Create a new bar button item that will send
        // addNewItem: to BNRItemsViewController
        UIBarButtonItem * bbi = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewItem:)];
        
        // Set this bar button item as the right item in the navigationItem
        navItem.rightBarButtonItem = bbi;
        
        navItem.leftBarButtonItem = self.editButtonItem;
    }
    
    return self;
}

- (instancetype)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //BNRDetailViewController * detailViewController = [[BNRDetailViewController alloc] init];
    BNRDetailViewController * detailViewController = [[BNRDetailViewController alloc] initForNewItem:NO];
    NSArray * items = [[BNRItemStore sharedStore] allItems];
    BNRitem * selectedItem = items[indexPath.row];
    
    //Give Detail view Controller a pointer to the item object in row
    detailViewController.item = selectedItem;
    
    //Push it onto the top of the navigation controller's stack
    [self.navigationController pushViewController:detailViewController
                                         animated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView
            numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allItems] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Get a new or recycled cell
    BNRItemCell *cell = [tableView dequeueReusableCellWithIdentifier:@"BNRItemCell" forIndexPath:indexPath];
    NSArray * items = [[BNRItemStore sharedStore] allItems];
    BNRitem * item = items[indexPath.row];
    
    //Configure the cell with the BNRItem
    cell.nameLabel.text = item.itemName;
    cell.serialNumberLabel.text = item.serialNumber;
    cell.valueLabel.text = [NSString stringWithFormat:@"$%d", item.valueInDollars];
    cell.thumbnailView.image = item.thumbnail;
    
    __weak BNRItemCell * weakCell = cell;
    
    cell.actionBlock = ^{
        NSLog(@"Going to show image for %@", item);
        
        BNRItemCell *strongCell = weakCell;
        
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            NSString * itemKey = item.itemKey;
            
            // If there is no image, we don't need to display anything
            UIImage * img = [[BNRImageStore sharedStore] imageForKey:itemKey];
            if (!img) {
                return ;
            }
            
            // Make a rectangle for the frame of the thumbnail relative to
            // our table view
            CGRect rect = [self.view convertRect:strongCell.thumbnailView.bounds fromView:strongCell.thumbnailView];
            
            // Create a new BNRImageViewController and set its image
            BNRImageViewController * ivc = [[BNRImageViewController alloc] init];
            ivc.image = img;
            
            // Present a 600x600 popover from the rect
            self.imagePopover = [[UIPopoverController alloc] initWithContentViewController:ivc];
            self.imagePopover.delegate = self;
            self.imagePopover.popoverContentSize = CGSizeMake(600, 600);
            [self.imagePopover presentPopoverFromRect:rect inView:self.view
                             permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        }
    };
    return cell;

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load the NIB file
    UINib * nib = [UINib nibWithNibName:@"BNRItemCell" bundle:nil];
    
    // Register this NIB, which contains the cell
    [self.tableView registerNib:nib forCellReuseIdentifier:@"BNRItemCell"];
}

//other method Here

-(IBAction)addNewItem:(id)sender
{
    //Create a new BNRitem and add it to the store
    BNRitem * newItem = [[BNRItemStore sharedStore] createItem];
    
    BNRDetailViewController * detailViewController = [[BNRDetailViewController alloc] initForNewItem:YES];
    
    detailViewController.item = newItem;
    
    detailViewController.dismissBlock = ^{[self.tableView reloadData];};
    
    UINavigationController * navController = [[UINavigationController alloc]
                                              initWithRootViewController:detailViewController];
    
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    
    //modal transitions
    navController.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    
    [self presentViewController:navController animated:YES completion:nil];
    
    //Figure out where that item is in the array
    //NSInteger lastRow = [[[BNRItemStore sharedStore] allItems] indexOfObject:newItem];
    
    //NSIndexPath * indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
    
    //Insert this new row into the table.
    //[self.tableView insertRowsAtIndexPaths:@[indexPath]
    //                      withRowAnimation:UITableViewRowAnimationTop];
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
    [[BNRItemStore sharedStore]
     moveItemAtIndex:sourceIndexPath.row
     toIndex:destinationIndexPath.row];
}


-(NSString *)tableView:(UITableView *)tableView
titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"Remove";
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController
{
    self.imagePopover = nil;
}
@end
