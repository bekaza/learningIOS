//
//  BNRAssetTypeViewController.m
//  Homepwner
//
//  Created by manit on 7/2/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRAssetTypeViewController.h"
#import "BNRItemStore.h"
#import "BNRItem.h"
@implementation BNRAssetTypeViewController

-(instancetype)init
{
    return [super initWithStyle:UITableViewStylePlain];
}

-(instancetype)initWithStyle:(UITableViewStyle)style
{
    if (self) {
        self.navigationItem.title = NSLocalizedString(@"Asset Type", @"BNRAssetTypeViewController title");
    }
    return [self init];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    return [[[BNRItemStore sharedStore] allAssetTypes] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                             forIndexPath:indexPath];
    NSArray * allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject * assetType = allAssets[indexPath.row];
    
    NSString * assetLabel = [assetType valueForKeyPath:@"Label"];
    cell.textLabel.text = assetLabel;
    
    if (assetType == self.item.assetType) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    
    NSArray * allAssets = [[BNRItemStore sharedStore] allAssetTypes];
    NSManagedObject * assetType = allAssets[indexPath.row];
    self.item.assetType = assetType;
    [self.navigationController popViewControllerAnimated:YES];
}
@end
