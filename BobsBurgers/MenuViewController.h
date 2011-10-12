//
//  MenuViewController.h
//  BobsBurgers
//
//  Created by Robert Murphy on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainDelegate.h"
#import "GroupedTableViewController.h"

@interface MenuViewController : UIViewController {
    NSString *locationName;
    GroupedTableViewController *tableView;
    BOOL admin;
    id<MainDelegate> delegate;
    UITextField *raisePricesField;
}
- (id)initWithName:(NSString*)name;

@property BOOL admin;
@property (nonatomic, retain) NSString *locationName;
@property (nonatomic, retain) GroupedTableViewController *tableView;
@property (nonatomic, assign) id<MainDelegate> delegate;

@end
