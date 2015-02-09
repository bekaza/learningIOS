//
//  BNRItemCell.m
//  Homepwner
//
//  Created by manit on 4/2/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRItemCell.h"

@interface BNRItemCell()

@property (nonatomic, weak) IBOutlet NSLayoutConstraint * imageViewHeightConstraints;
//@property (nonatomic, weak) IBOutlet NSLayoutConstraint * imageViewWidthConstraints;

@end

@implementation BNRItemCell

-(IBAction)showImage:(id)sender
{
    if (self.actionBlock) {
        self.actionBlock();
    }
}

-(void)updateInterfaceForDynamicTypeSize
{
    UIFont * font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
    self.nameLabel.font = font;
    self.serialNumberLabel.font = font;
    self.valueLabel.font = font;
    
    static NSDictionary * imageSizeDictionary;
    
    if (!imageSizeDictionary) {
        imageSizeDictionary = @{UIContentSizeCategoryExtraSmall: @44,
                                UIContentSizeCategorySmall:@44,
                                UIContentSizeCategoryMedium:@44,
                                UIContentSizeCategoryLarge:@44,
                                UIContentSizeCategoryExtraLarge:@55,
                                UIContentSizeCategoryExtraExtraLarge:@65,
                                UIContentSizeCategoryExtraExtraExtraLarge:@75 };
    }
    
    NSString * userSize = [[UIApplication sharedApplication] preferredContentSizeCategory];
    NSNumber * imageSize = imageSizeDictionary[userSize];
    self.imageViewHeightConstraints.constant = imageSize.floatValue;
    //self.imageViewWidthConstraints.constant = imageSize.floatValue;
}

-(void)awakeFromNib
{
    [self updateInterfaceForDynamicTypeSize];
    
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(updateInterfaceForDynamicTypeSize)
               name:UIContentSizeCategoryDidChangeNotification
             object:nil];
    
    NSLayoutConstraint * constraint = [NSLayoutConstraint constraintWithItem:self.thumbnailView
                                                                   attribute:NSLayoutAttributeHeight
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:self.thumbnailView
                                                                   attribute:NSLayoutAttributeWidth
                                                                  multiplier:1
                                                                    constant:0];
    [self.thumbnailView addConstraint:constraint];
}

-(void)dealloc
{
    NSNotificationCenter * nc = [NSNotificationCenter defaultCenter];
    [nc removeObserver:self];
}

@end
