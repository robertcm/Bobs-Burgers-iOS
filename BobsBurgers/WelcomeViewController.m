//
//  WelcomeViewController.m
//  BobsBurgers
//
//  Created by Robert Murphy on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "WelcomeViewController.h"

@implementation WelcomeViewController
@synthesize delegate;

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

// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    self.view = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 1024)] autorelease];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *customerButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    customerButton.frame = CGRectMake(234, 200, 300, 80);
    [customerButton setTitle:@"Customer View" forState:UIControlStateNormal];
    [customerButton addTarget:self action:@selector(customerPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:customerButton];
    
    UIButton *adminButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    adminButton.frame = CGRectMake(234, 400, 300, 40);
    [adminButton setTitle:@"Administrator Login" forState:UIControlStateNormal];
    [adminButton addTarget:self action:@selector(adminPressed) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:adminButton];
    
    textField = [[[UITextField alloc] initWithFrame:CGRectMake(234, 350, 300, 40)] autorelease];
    textField.secureTextEntry = YES;
    textField.delegate = self;
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.placeholder = @"Password (it's \"bobby\")";
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [self.view addSubview:textField];
}

//Button selectors
- (void)customerPressed {
    [self.delegate customersPressed];
}
- (void)adminPressed {
    if (textField.text) [self.delegate adminPressedWithPassword:textField.text];
}

//Also go on "return"
- (BOOL)textFieldShouldReturn:(UITextField *)tf {
    if (textField.text) [self.delegate adminPressedWithPassword:textField.text];
    return YES;
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
