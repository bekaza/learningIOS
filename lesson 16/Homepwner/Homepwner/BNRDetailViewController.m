//
//  BNRDetailViewController.m
//  Homepwner
//
//  Created by manit on 28/1/2558.
//  Copyright (c) พ.ศ. 2558 golf. All rights reserved.
//

#import "BNRDetailViewController.h"
#import "BNRitem.h"
#import "BNRImageStore.h"

@interface BNRDetailViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *serialNumberField;
@property (weak, nonatomic) IBOutlet UITextField *valueField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIToolbar *toolBar;

- (IBAction)backgroundTapped:(id)sender;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *removeImage;

@end

@implementation BNRDetailViewController

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    BNRitem * item = self.item;
    
    self.nameField.text = item.itemName;
    self.serialNumberField.text = item.serialNumber;
    self.valueField.text = [NSString stringWithFormat:@"%d", item.valueInDollars];
    
    //You need an NSDateFormatter that will turn a date into a simple date string
    
    static NSDateFormatter * dateFormatter = nil;
    
    if (!dateFormatter) {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    
    //Use filtered NSDate object to set dateLabel contents
    self.dateLabel.text = [dateFormatter stringFromDate:item.dateCreated];
    
    NSString * key = self.item.itemKey;
    //NSLog(@"%@",key);
    
    // Get the image for its image key from the image store
    UIImage * imageToDisplay = [[BNRImageStore sharedStore] imageForKey:key];
    //NSLog(@"%@",imageToDisplay);
    // Use that image to put on the screen in the imageView
    self.imageView.image = imageToDisplay;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    //Clear first responder
    [self.view endEditing:YES];
    
    // "Save" changes to item
    BNRitem * item = self.item;
    item.itemName = self.nameField.text;
    item.serialNumber = self.serialNumberField.text;
    item.valueInDollars = [self.valueField.text intValue];
    
}

-(void)setItem:(BNRitem *)item
{
    _item = item;
    self.navigationItem.title = _item.itemName;
}
- (IBAction)takePicture:(id)sender
{
    UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
    
    // If the device has a camera, take a picture, otherwise,
    // just pick from photo libary
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }else{
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    imagePicker.delegate = self;
    imagePicker.allowsEditing = YES;
    // Place image picker on the screen
    [self presentViewController:imagePicker animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //NSLog(@"Get Image");
    
    /*Get picked image Origin from info dictionary
    UIImage * image = info[UIImagePickerControllerOriginalImage];*/
    
    // Get picked edit image
    UIImage * image = info[UIImagePickerControllerEditedImage];
    
    // Store the image in the BNRImageStore for this key
    [[BNRImageStore sharedStore] setImage:image forKey:self.item.itemKey];
    //NSLog(@"%@",image);
    // Put that image onto the screen in our image view
    self.imageView.image = image;
    
    // Take image picker off the screee -
    // you must call this dismiss method
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [self.view endEditing:YES];
}

- (IBAction)deleteImage:(id)sender
{
    NSString * key = self.item.itemKey;
    
    [[BNRImageStore sharedStore] deleteImageForKey:key];
    
    [self.imageView setImage:nil];
}

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    UIImageView * iv = [[UIImageView alloc] initWithImage:nil];
    
    // The ContentMode of the image view in the XIB was Aspect Fit
    iv.contentMode = UIViewContentModeScaleAspectFit;
    
    // Do not produce a translated constraint for this view
    iv.translatesAutoresizingMaskIntoConstraints = NO;
    
    // The image view was a subview of the view
    [self.view addSubview:iv];
    
    // The image view was pointed to by the imageview property
    self.imageView = iv;
    
    NSDictionary * nameMap = @{@"imageView": self.imageView,
                               @"dateLabel": self.dateLabel,
                               @"toolbar": self.toolBar};
    
    // imageView is 0 pts from superview at left and right edges
    NSArray *  horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[imageView]-0-|"
                                                                               options:0
                                                                               metrics:nil
                                                                                 views:nameMap];
    
    // imageView is 8 pts from dateLabel at its top edge...
    // ... and 8 pts from toolbar at its bottom edge
    NSArray * verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[dateLabel]-[imageView]-[toolbar]"
                                                                            options:0
                                                                            metrics:nil
                                                                              views:nameMap];
    [self.view addConstraints:horizontalConstraints];
    [self.view  addConstraints:verticalConstraints];
    
    // Set the vertical priorities to be less than
    // those of the other subviews
    [self.imageView setContentHuggingPriority:200 forAxis:UILayoutConstraintAxisVertical];
    [self.imageView setContentCompressionResistancePriority:700 forAxis:UILayoutConstraintAxisVertical];
}

@end
