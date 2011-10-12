//
//  BobsBurgersAppDelegate.h
//  BobsBurgers
//
//  Created by Robert Murphy on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WelcomeViewController.h"
#import "ChooseLocationViewController.h"
#import "MenuViewController.h"
#import "NewItemViewController.h"
#import "MainDelegate.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"

@interface BobsBurgersAppDelegate : NSObject <UIApplicationDelegate, MainDelegate, ASIHTTPRequestDelegate> {
    UINavigationController *navController;
    NSString *admin_password;
    int current_view;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) UINavigationController *navController;
@property (nonatomic, retain) NSString *admin_password;
@end
