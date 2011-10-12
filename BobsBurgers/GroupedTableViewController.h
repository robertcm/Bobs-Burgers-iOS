//
//  GroupedTableViewController.h
//  BobsBurgers
//
//  Created by Robert Murphy on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainDelegate.h"
#import "AsyncImageView.h"


@interface GroupedTableViewController : UITableViewController {
    NSMutableArray *sections;
    NSMutableDictionary *itemsForSections;
    int type;
    BOOL admin;
    NSString *locationName;
    id<MainDelegate> delegate;
}

- (id)initWithType:(int)t;
- (void)setSectionsAndItems:(NSMutableArray*)s items:(NSMutableDictionary*)i;

@property (nonatomic, retain) NSMutableArray *sections;
@property (nonatomic, retain) NSMutableDictionary *itemsForSections;
@property int type;
@property BOOL admin;
@property (nonatomic, retain) NSString *locationName;
@property (nonatomic, assign) id<MainDelegate> delegate;

@end
