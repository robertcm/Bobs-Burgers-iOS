//
//  NewItemViewController.m
//  BobsBurgers
//
//  Created by Robert Murphy on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "NewItemViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation NewItemViewController
@synthesize delegate, locationName, editing, previousName, priceField, nameField, pickerView, imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)] autorelease];
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(234, 40, 300, 40)] autorelease];
    label.text = self.editing ? @"Edit Menu Item" : @"New Menu Item";
    label.font = [UIFont systemFontOfSize:24];
    label.textAlignment = UITextAlignmentCenter;
    [self.view addSubview:label];
    
    //name field
    self.nameField = [[[UITextField alloc] initWithFrame:CGRectMake(234, 100, 300, 40)] autorelease];
    self.nameField.borderStyle = UITextBorderStyleRoundedRect;
    self.nameField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.nameField.placeholder = @"Name";
    [self.view addSubview:nameField];
    
    self.priceField = [[[UITextField alloc] initWithFrame:CGRectMake(234, 150, 300, 40)] autorelease];
    self.priceField.borderStyle = UITextBorderStyleRoundedRect;
    self.priceField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.priceField.placeholder = @"Price";
    self.priceField.keyboardType = UIKeyboardTypeDecimalPad;
    [self.view addSubview:priceField];
    
    UILabel *categoryLabel = [[[UILabel alloc] initWithFrame:CGRectMake(234, 200, 300, 40)] autorelease];
    categoryLabel.text = @"Category:";
    [self.view addSubview:categoryLabel];
    
    self.pickerView = [[[UIPickerView alloc] initWithFrame:CGRectMake(234, 240, 290, 200)] autorelease];
    self.pickerView.delegate = self;
    self.pickerView.showsSelectionIndicator = YES;
    [self.view addSubview:pickerView];
    
    self.imageView = [[[AsyncImageView alloc] initWithFrame:CGRectMake(234, 440, 50, 50)] autorelease];
    self.imageView.backgroundColor = [UIColor whiteColor];
    self.imageView.layer.borderColor = [UIColor blackColor].CGColor;
    self.imageView.layer.borderWidth = 1;
    self.imageView.contentMode = UIViewContentModeScaleToFill;
    
    [self.view addSubview:imageView];
    
    UIButton *imageButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    imageButton.frame = CGRectMake(294, 440, 240, 50);
    [imageButton setTitle:@"Choose Image" forState:UIControlStateNormal];
    [imageButton addTarget:self action:@selector(imageButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:imageButton];
    
    UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [doneButton setTitle:@"Save" forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(donePressed) forControlEvents:UIControlEventTouchUpInside];
    doneButton.frame = CGRectMake(234, 510, 300, 50);
    
    [self.view addSubview:doneButton];
}

- (void)imageButtonPressed {
    UIImagePickerController *imagePicker = [[[UIImagePickerController alloc] init] autorelease];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    imagePicker.delegate = self;
    imagePicker.allowsEditing = NO;
    [self presentModalViewController:imagePicker animated:YES];
}
- (void)donePressed {
    NSLog(@"1");
    //check non-nil name and price
    if (nameField.text && priceField.text) {
        NSLog(@"2");
        //check valid name and price
        if (![nameField.text isEqualToString:@""] && [priceField.text floatValue]!=0.0) {
            NSLog(@"3");
            //get category string, we add "s" here for consistency with the menu view
            NSString *category = @"Desserts";
            int selectedRow = [pickerView selectedRowInComponent:0];
            if (selectedRow==0) {
                category = @"Salads";
            }
            if (selectedRow==1) {
                category = @"Burgers";
            }
            if (self.editing) {
                [self.delegate updateItem:self.locationName previousName:self.previousName name:nameField.text price:priceField.text category:category image:[self getSmallImage:imageView.image]];
            } else {
                [self.delegate addItem:self.locationName name:nameField.text price:priceField.text category:category image:[self getSmallImage:imageView.image]];
            }
            return;
        }
    } 
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Something isn't right..." delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
    [alert show];
}

//Scale image down to the size of the imageView and use this to upload
-(UIImage*)getSmallImage:(UIImage*)source {
    
    UIImageView *copy = [[[UIImageView alloc] initWithFrame:imageView.frame] autorelease];
    copy.backgroundColor = [UIColor whiteColor];
    copy.contentMode = UIViewContentModeScaleToFill;
    copy.image = source;
    
    UIGraphicsBeginImageContext(copy.frame.size);
    [copy.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
-(void)setItem:(NSDictionary*)dict {
    NSLog(@"right here");
    self.previousName = [dict objectForKey:@"name"];
    nameField.text = [dict objectForKey:@"name"];
    priceField.text = [dict objectForKey:@"price"];
    [imageView loadFromURLString:[NSString stringWithFormat:@"%@locations/%@/%@/image", BASE_URL, self.locationName, [dict objectForKey:@"name"]]];
    NSString *category = [dict objectForKey:@"category"];
    if ([category isEqualToString:@"Salads"]) [pickerView selectRow:0 inComponent:0 animated:NO];
    else if ([category isEqualToString:@"Burgers"]) [pickerView selectRow:1 inComponent:0 animated:NO];
    else if ([category isEqualToString:@"Desserts"]) [pickerView selectRow:2 inComponent:0 animated:NO];
}

//UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
    imageView.image = image;
    [self dismissModalViewControllerAnimated:YES];
}

//UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSUInteger numRows = 3;
    
    return numRows;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row==0) return @"Salad";
    if (row==1) return @"Burger";
    return @"Dessert";
}

- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component {
    return 290;
}

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)dealloc {
    [priceField release];
    [nameField release];
    [pickerView release];
    [imageView release];
    [previousName release];
    [locationName release];
    [super dealloc];
}

@end
