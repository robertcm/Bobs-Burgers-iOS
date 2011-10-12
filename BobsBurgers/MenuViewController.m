//
//  MenuViewController.m
//  BobsBurgers
//
//  Created by Robert Murphy on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuViewController.h"

@implementation MenuViewController
@synthesize locationName, tableView, admin, delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithName:(id)name {
    self = [super init];
    if (self) {
        self.locationName = name;
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
    
    UILabel *label = [[[UILabel alloc] initWithFrame:CGRectMake(84, 30, 600, 40)] autorelease];
    label.textAlignment = UITextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:24];
    label.text = self.locationName;
    
    [self.view addSubview:label];
    
    self.tableView = [[GroupedTableViewController alloc] initWithType:MENU];
    tableView.view.frame = CGRectMake(84, 84, 600, 856);
    tableView.admin = self.admin;
    tableView.delegate = self.delegate;
    tableView.locationName = self.locationName;
    [self.view addSubview:tableView.view];
    
    //"Add Item" Button for Admin-View
    if (self.admin) {
        UIButton *addItem = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addItem.frame = CGRectMake(534, 30, 150, 40);
        [addItem setTitle:@"Add Item" forState:UIControlStateNormal];
        [addItem addTarget:self action:@selector(addItemPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addItem];
        
        raisePricesField = [[[UITextField alloc] initWithFrame:CGRectMake(84, 30, 50, 40)] autorelease];
        raisePricesField.borderStyle = UITextBorderStyleRoundedRect;
        raisePricesField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        raisePricesField.placeholder = @"$$";
        raisePricesField.keyboardType = UIKeyboardTypeNumberPad;
        [self.view addSubview:raisePricesField];
        
        UIButton *deleteImagesButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        deleteImagesButton.frame = CGRectMake(234, 30, 80, 40);
        [deleteImagesButton setTitle:@"X Images" forState:UIControlStateNormal];
        [deleteImagesButton addTarget:self action:@selector(deleteImagesButtonPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:deleteImagesButton];
        
        UIButton *raisePrices = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        raisePrices.frame = CGRectMake(134, 30, 100, 40);
        [raisePrices setTitle:@"Raise Prices" forState:UIControlStateNormal];
        [raisePrices addTarget:self action:@selector(raisePricesPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:raisePrices];
    }
}

- (void)deleteImagesButtonPressed {
    [self.delegate batchRemoveImages:self.locationName];
}
- (void)raisePricesPressed {
    if (raisePricesField.text) {
        if ([raisePricesField.text floatValue]!=0.0) {
            [self.delegate batchRaisePrices:self.locationName value:raisePricesField.text];
            return;
        }
    }
    UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Can't raise by that amount" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
    [alert show];
}

- (void)addItemPressed {
    [self.delegate goAddItemView:self.locationName];
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
    [locationName release];
    [super dealloc];
}

@end
