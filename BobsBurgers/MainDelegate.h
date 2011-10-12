//
//  MainDelegate.h
//  BobsBurgers
//
//  Created by Robert Murphy on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#define BASE_URL @"http://bestofbobburgers.appspot.com/"

//VIEWS
#define WELCOME 0
#define LOCATION 1
#define MENU 2
#define ITEM 3


@protocol MainDelegate <NSObject>

-(void)customersPressed;
-(void)adminPressedWithPassword:(NSString*)password;
-(void)tableRowSelected:(NSString*)title from:(int)source admin:(BOOL)admin;
-(void)goAddItemView:(NSString*)locationName;
/*
 * REQUESTS
 */
-(void)getLocations;
-(void)addLocation:(NSString*)name;
-(void)deleteLocation:(NSString*)name;

-(void)getItems:(NSString*)locationName;
-(void)addItem:(NSString*)locationName name:(NSString*)name price:(NSString*)price category:(NSString*)category image:(UIImage*)image;
-(void)deleteItem:(NSString*)name;
-(void)updateItem:(NSString*)locationName previousName:(NSString*)prev name:(NSString*)name price:(NSString*)price category:(NSString*)category image:(UIImage*)image;

-(void)getItem:(NSString*)locationName item:(NSString*)i;


-(void)batchRaisePrices:(NSString*)locationName value:(NSString*)v;
-(void)batchRemoveImages:(NSString*)locationName;
@end
