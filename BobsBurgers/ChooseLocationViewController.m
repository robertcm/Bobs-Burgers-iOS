//
//  ChooseLocationViewController.m
//  BobsBurgers
//
//  Created by Robert Murphy on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ChooseLocationViewController.h"

@implementation ChooseLocationViewController
@synthesize delegate, admin, tableView;

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
    
    self.tableView = [[GroupedTableViewController alloc] initWithType:LOCATION];
    self.tableView.delegate = self.delegate;
    self.tableView.view.frame = CGRectMake(84, 84, 600, 856);
    self.tableView.admin = self.admin;
    [self.view addSubview:tableView.view];
    
    if (self.admin) {
        textField = [[[UITextField alloc] initWithFrame:CGRectMake(154, 30, 300, 40)] autorelease];
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        textField.autocorrectionType = UITextAutocorrectionTypeNo;
        textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        textField.placeholder = @"Location Name";
        textField.borderStyle = UITextBorderStyleRoundedRect;
        [self.view addSubview:textField];
        
        UIButton *addLocation = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        addLocation.frame = CGRectMake(464, 30, 150, 40);
        [addLocation setTitle:@"Add Location" forState:UIControlStateNormal];
        [addLocation addTarget:self action:@selector(addLocationPressed) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:addLocation];
    }
    
}

- (void)addLocationPressed {
    [self.delegate addLocation:textField.text];
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

@end
