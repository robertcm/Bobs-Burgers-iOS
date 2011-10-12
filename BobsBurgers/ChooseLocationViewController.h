//
//  ChooseLocationViewController.h
//  BobsBurgers
//
//  Created by Robert Murphy on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GroupedTableViewController.h"
#import "MainDelegate.h"

@interface ChooseLocationViewController : UIViewController {
    id<MainDelegate> delegate;
    BOOL admin;
    UITextField *textField;
    GroupedTableViewController *tableView;
}

@property BOOL admin;
@property (nonatomic, assign) id<MainDelegate> delegate;
@property (nonatomic, retain) GroupedTableViewController *tableView;
@end
