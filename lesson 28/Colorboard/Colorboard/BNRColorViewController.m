//
//  BNRColorViewController.m
//  Colorboard
//
//  Created by manit on 10/2/2558.
//  Copyright (c) พ.ศ. 2558 BIg Nerd Ranch. All rights reserved.
//

#import "BNRColorViewController.h"


@interface BNRColorViewController()

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISlider *redSlider;
@property (weak, nonatomic) IBOutlet UISlider *greenSlider;
@property (weak, nonatomic) IBOutlet UISlider *blueSlider;

@end

@implementation BNRColorViewController

-(IBAction)changeColor:(id)sender
{
    float red = self.redSlider.value;
    float green = self.greenSlider.value;
    float blue = self.blueSlider.value;
    UIColor * newColor = [UIColor colorWithRed:red
                                         green:green
                                          blue:blue
                                         alpha:1.0];
    self.view.backgroundColor = newColor;
}

-(IBAction)dismiss:(id)sender
{

    [self.presentingViewController dismissViewControllerAnimated:YES
                                                      completion:nil];
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.existingColor) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.leftBarButtonItem = nil;
    }
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIColor * color = self.colorDescription.color;
    
    float red, green, blue;
    
    [color getRed:&red green:&green blue:&blue alpha:nil];
    self.redSlider.value = red;
    self.greenSlider.value = green;
    self.blueSlider.value = blue;
    
    self.view.backgroundColor = color;
    self.textField.text = self.colorDescription.name;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];

        self.colorDescription.name = self.textField.text;
        self.colorDescription.color = self.view.backgroundColor;
}
@end
