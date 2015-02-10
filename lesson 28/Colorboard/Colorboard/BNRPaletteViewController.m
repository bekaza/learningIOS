//
//  BNRPaletteViewController.m
//  Colorboard
//
//  Created by manit on 10/2/2558.
//  Copyright (c) พ.ศ. 2558 BIg Nerd Ranch. All rights reserved.
//

#import "BNRPaletteViewController.h"
#import "BNRColorViewController.h"
#import "BNRColorDescription.h"

@interface BNRPaletteViewController()

@property (nonatomic) NSMutableArray * colors;

@end

@implementation BNRPaletteViewController

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"NewColor"]) {
        BNRColorDescription * color = [[BNRColorDescription alloc] init];
        [self.colors addObject:color];
        
        UINavigationController * nc =
            (UINavigationController *)segue.destinationViewController;
        BNRColorViewController * mvc =
            (BNRColorViewController *)[nc topViewController];
        mvc.colorDescription = color;
    }else if ([segue.identifier isEqualToString:@"ExistingColor"]){
        
        NSLog(@"Existing Color");
        NSIndexPath * ip = [self.tableView indexPathForCell:sender];
        BNRColorDescription * color = self.colors[ip.row];
        BNRColorViewController * cvc =
            (BNRColorViewController *)segue.destinationViewController;
        cvc.colorDescription = color;
        cvc.existingColor = YES;
    }
}

-(NSMutableArray *)colors
{
    if (!_colors) {
        _colors = [NSMutableArray array];
        
        BNRColorDescription * cd = [[BNRColorDescription alloc] init];
        [_colors addObject:cd];
    }
    
    return _colors;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView
numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"%d", [self.colors count]);
    return [self.colors count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView
        cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"
                                                             forIndexPath:indexPath];
    
    BNRColorDescription * color = self.colors[indexPath.row];
    cell.textLabel.text = color.name;
    
    return cell;
}

@end
