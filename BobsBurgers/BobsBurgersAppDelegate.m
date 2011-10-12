//
//  BobsBurgersAppDelegate.m
//  BobsBurgers
//
//  Created by Robert Murphy on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//


//URL Tags
#define AUTH 0
#define GET_LOCATIONS 1
#define ADD_LOCATION 2
#define DELETE_LOCATION 3
#define GET_ITEMS 4
#define ADD_ITEM 5
#define GET_ITEM 6
#define UPDATE_ITEM 7
#define DELETE_ITEM 8
#define BATCH_RAISE 9
#define BATCH_REMOVE 10

#import "BobsBurgersAppDelegate.h"

@implementation BobsBurgersAppDelegate

@synthesize window = _window, navController, admin_password;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    WelcomeViewController *welcomeViewController = [[[WelcomeViewController alloc] init] autorelease];
    welcomeViewController.delegate = self;
    self.navController = [[[UINavigationController alloc] initWithRootViewController:welcomeViewController] autorelease];
    self.window.rootViewController = self.navController;
    
    [self.window makeKeyAndVisible];
    current_view = WELCOME;
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

//MainDelegate methods
- (void)customersPressed {
    ChooseLocationViewController *chooseLocationViewController = [[[ChooseLocationViewController alloc] init] autorelease];
    chooseLocationViewController.delegate = self;
    [self.navController pushViewController:chooseLocationViewController animated:YES];
    [self getLocations];
    current_view = LOCATION;
}
- (void)adminPressedWithPassword:(NSString*)password {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@auth", BASE_URL]];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    [req setTag:AUTH];
    [req setDelegate:self];
    [req setUserInfo:[NSDictionary dictionaryWithObject:password forKey:@"password"]];
    [req setPostValue:password forKey:@"password"];
    [req startAsynchronous];
}
- (void)tableRowSelected:(NSString *)title from:(int)source admin:(BOOL)admin {
    if (source==LOCATION) {
        [self getItems:title];
        MenuViewController *menuViewController = [[[MenuViewController alloc] initWithName:title] autorelease];
        menuViewController.admin = admin;
        menuViewController.delegate = self;
        [self.navController pushViewController:menuViewController animated:YES];
        current_view = MENU;
    }
    if (source==MENU) {
        NewItemViewController *newItemViewController = [[[NewItemViewController alloc] init] autorelease];
        newItemViewController.locationName = ((MenuViewController*)self.navController.visibleViewController).locationName;
        newItemViewController.delegate = self;
        newItemViewController.editing = YES;
        [self.navController pushViewController:newItemViewController animated:YES];
        [self getItem:newItemViewController.locationName item:title];
        
        current_view = ITEM;
    }
}
- (void)goAddItemView:(NSString*)locationName {
    NewItemViewController *newItemViewController = [[[NewItemViewController alloc] init] autorelease];
    newItemViewController.locationName = locationName;
    newItemViewController.delegate = self;
    [self.navController pushViewController:newItemViewController animated:YES];
    
    current_view = ITEM;
}

//Location Requests
- (void)getLocations {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@locations", BASE_URL]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setRequestMethod:@"GET"];
    [req setTag:GET_LOCATIONS];
    [req setDelegate:self];
    [req startAsynchronous];
}

- (void)addLocation:(NSString *)name {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@locations", BASE_URL]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setTag:ADD_LOCATION];
    [req setDelegate:self];
    SBJsonWriter *writer = [[[SBJsonWriter alloc] init] autorelease];
    NSString *json = [writer stringWithObject:[NSDictionary dictionaryWithObjectsAndKeys:self.admin_password, @"password", name, @"name", nil]];
    [req appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [req setRequestMethod:@"POST"];
    [req startAsynchronous];
}

- (void)deleteLocation:(id)name {
    NSLog(@"string url is %@", [NSString stringWithFormat:@"%@locations/%@", BASE_URL, name]);
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@locations/%@", BASE_URL, name]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    
    [req setTag:DELETE_LOCATION];
    [req setDelegate:self];
    /*
     //For some reason AppEngine doesn't support a body in DELETE requests
    SBJsonWriter *writer = [[[SBJsonWriter alloc] init] autorelease];
    NSString *json = [writer stringWithObject:[NSDictionary dictionaryWithObjectsAndKeys:self.admin_password, @"password", nil]];
    [req appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [req buildPostBody];
     */
    [req setRequestMethod:@"DELETE"];
    [req startAsynchronous];
}

//Items Requests
-(void)getItems:(NSString*)locationName {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@locations/%@", BASE_URL, locationName]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setRequestMethod:@"GET"];
    [req setTag:GET_ITEMS];
    [req setDelegate:self];
    [req startAsynchronous];
}
-(void)addItem:(NSString*)locationName name:(NSString*)name price:(NSString*)price category:(NSString*)category image:(UIImage *)image {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@locations/%@", BASE_URL, locationName]];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    [req setRequestMethod:@"POST"];
    [req setTag:ADD_ITEM];
    [req setDelegate:self];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.admin_password forKey:@"password"];
    [dict setObject:name forKey:@"name"];
    [dict setObject:price forKey:@"price"];
    [dict setObject:category forKey:@"category"];
    SBJsonWriter *writer = [[[SBJsonWriter alloc] init] autorelease];
    NSString *json = [writer stringWithObject:dict];
    [req addData:UIImageJPEGRepresentation(image, 1.0) forKey:@"image"];
    [req addPostValue:json forKey:@"json"];
    [req startAsynchronous];
}
-(void)deleteItem:(NSString*)name {
    NSString *urlString = [[NSString stringWithFormat:@"%@locations/%@/%@", BASE_URL, ((MenuViewController*)self.navController.visibleViewController).locationName, name] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setTag:DELETE_ITEM];
    [req setDelegate:self];
    /*
     //For some reason AppEngine doesn't support a body in DELETE requests
    SBJsonWriter *writer = [[[SBJsonWriter alloc] init] autorelease];
    NSString *json = [writer stringWithObject:[NSDictionary dictionaryWithObjectsAndKeys:self.admin_password, @"password", nil]];
    [req appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [req buildPostBody];
     */
    [req setRequestMethod:@"DELETE"];
    [req startAsynchronous];
}
-(void)updateItem:(NSString*)locationName previousName:(NSString*)prev name:(NSString*)name price:(NSString*)price category:(NSString*)category image:(UIImage *)image {
    NSString *urlString = [[NSString stringWithFormat:@"%@locations/%@/%@", BASE_URL, locationName, prev] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIFormDataRequest *req = [ASIFormDataRequest requestWithURL:url];
    [req setTag:UPDATE_ITEM];
    [req setDelegate:self];
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [dict setObject:self.admin_password forKey:@"password"];
    [dict setObject:name forKey:@"name"];
    [dict setObject:price forKey:@"price"];
    [dict setObject:category forKey:@"category"];
    SBJsonWriter *writer = [[[SBJsonWriter alloc] init] autorelease];
    NSString *json = [writer stringWithObject:dict];
    [req addData:UIImageJPEGRepresentation(image, 1.0) forKey:@"image"];
    [req addPostValue:json forKey:@"json"];
    [req startAsynchronous];
}

//Item Requests
-(void)getItem:(NSString*)locationName item:(NSString*)i {
    NSString *urlString = [[NSString stringWithFormat:@"%@locations/%@/%@", BASE_URL, locationName, i] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSURL *url = [NSURL URLWithString:urlString];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setRequestMethod:@"GET"];
    [req setTag:GET_ITEM];
    [req setDelegate:self];
    [req startAsynchronous];
}

//Batch Requests
-(void)batchRaisePrices:(NSString*)locationName value:(NSString*)v {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@batch/raise_prices", BASE_URL]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    SBJsonWriter *writer = [[[SBJsonWriter alloc] init] autorelease];
    NSString *json = [writer stringWithObject:[NSDictionary dictionaryWithObjectsAndKeys:self.admin_password, @"password", v, @"price", locationName, @"location", nil]];
    [req appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [req buildPostBody];
    [req setRequestMethod:@"POST"];
    [req setTag:BATCH_RAISE];
    [req setDelegate:self];
    [req startAsynchronous];
}
-(void)batchRemoveImages:(NSString*)locationName {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@batch/remove_images", BASE_URL, locationName]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    SBJsonWriter *writer = [[[SBJsonWriter alloc] init] autorelease];
    NSString *json = [writer stringWithObject:[NSDictionary dictionaryWithObjectsAndKeys:self.admin_password, @"password", locationName, @"location", nil]];
    [req appendPostData:[json dataUsingEncoding:NSUTF8StringEncoding]];
    [req buildPostBody];
    [req setRequestMethod:@"POST"];
    [req setTag:BATCH_REMOVE];
    [req setDelegate:self];
    [req startAsynchronous];
}

//ASIHttpRequestDelegate Methods
- (void)requestFinished:(ASIHTTPRequest *)request {
    int tag = [request tag];
    SBJsonParser *parser = [[[SBJsonParser alloc] init] autorelease];
    if (tag==AUTH) {
        NSDictionary *dict = [parser objectWithString:[request responseString]];
        if ([[dict objectForKey:@"success"] boolValue]) {
            //Password is correct, go to admin view
            ChooseLocationViewController *chooseLocationViewController = [[[ChooseLocationViewController alloc] init] autorelease];
            chooseLocationViewController.delegate = self;
            chooseLocationViewController.admin = YES;
            [self getLocations];
            [self.navController pushViewController:chooseLocationViewController animated:YES];
            self.admin_password = [[request userInfo] objectForKey:@"password"];
        } else {
            //Password incorrect, display alert error
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Incorrect password!" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
            [alert show];
        }
        return;
    }
    if (tag==ADD_LOCATION) {
        NSDictionary *dict = [parser objectWithString:[request responseString]];
        if ([[dict objectForKey:@"success"] boolValue]) {
            NSLog(@"%@", dict);
            [((ChooseLocationViewController*)self.navController.visibleViewController).tableView setSectionsAndItems:[NSMutableArray arrayWithObject:@"Locations"] items:[NSMutableDictionary dictionaryWithObject:[dict objectForKey:@"Locations"] forKey:@"Locations"]];
        } else {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oops" message:@"Couldn't Connect" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    if (tag==DELETE_LOCATION) {
        NSLog(@"response: %@", [request responseString]);
    }
    if (tag==GET_LOCATIONS) {
        NSDictionary *dict = [parser objectWithString:[request responseString]];
        if ([[dict objectForKey:@"success"] boolValue]) {
            [((ChooseLocationViewController*)self.navController.visibleViewController).tableView setSectionsAndItems:[NSMutableArray arrayWithObject:@"Locations"] items:[NSMutableDictionary dictionaryWithObject:[dict objectForKey:@"Locations"] forKey:@"Locations"]];
        } else {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oops" message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    if (tag==GET_ITEMS) {
        NSDictionary *dict = [parser objectWithString:[request responseString]];
        if ([[dict objectForKey:@"success"] boolValue]) {
            [((MenuViewController*)self.navController.visibleViewController).tableView setSectionsAndItems:[NSMutableArray arrayWithArray:[[dict objectForKey:@"items"] allKeys]] items:[NSMutableDictionary dictionaryWithDictionary:[dict objectForKey:@"items"]]];
        } else {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oops" message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    if (tag==GET_ITEM) {
        NSDictionary *dict = [parser objectWithString:[request responseString]];
        if ([[dict objectForKey:@"success"] boolValue]) {
            [((NewItemViewController*)self.navController.visibleViewController) setItem:dict];
        } else {
        }
    }
    if (tag==ADD_ITEM) {
        NSDictionary *dict = [parser objectWithString:[request responseString]];
        if ([[dict objectForKey:@"success"] boolValue]) {
            [self getItems:((NewItemViewController*)self.navController.visibleViewController).locationName];
            [self.navController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oops" message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    if (tag==UPDATE_ITEM) {
        NSDictionary *dict = [parser objectWithString:[request responseString]];
        if ([[dict objectForKey:@"success"] boolValue]) {
            [self getItems:((NewItemViewController*)self.navController.visibleViewController).locationName];
            [self.navController popViewControllerAnimated:YES];
        } else {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oops" message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    if (tag==BATCH_RAISE) {
        NSDictionary *dict = [parser objectWithString:[request responseString]];
        if ([[dict objectForKey:@"success"] boolValue]) {
            [self getItems:((NewItemViewController*)self.navController.visibleViewController).locationName];
        } else {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oops" message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
    if (tag==BATCH_REMOVE) {
        NSDictionary *dict = [parser objectWithString:[request responseString]];
        if ([[dict objectForKey:@"success"] boolValue]) {
            [((MenuViewController*)self.navController.visibleViewController).tableView.tableView reloadData];
        } else {
            UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:@"Oops" message:[dict objectForKey:@"message"] delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil] autorelease];
            [alert show];
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request {
    NSLog(@"request failed");
}



- (void)dealloc
{
    [navController release];
    [admin_password release];
    [_window release];
    [super dealloc];
}

@end
