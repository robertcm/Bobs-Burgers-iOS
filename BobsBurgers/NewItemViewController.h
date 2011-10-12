//
//  NewItemViewController.h
//  BobsBurgers
//
//  Created by Robert Murphy on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainDelegate.h"
#import "AsyncImageView.h"

@interface NewItemViewController : UIViewController <UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    UITextField *nameField;
    UITextField *priceField;
    UIPickerView *pickerView;
    AsyncImageView *imageView;
    
    id<MainDelegate> delegate;
    
    NSString *locationName;
    NSString *previousName;
    BOOL editing;
}

-(UIImage*)getSmallImage:(UIImage*)source;
-(void)setItem:(NSDictionary*)dict;

@property BOOL editing;
@property (nonatomic, assign) id<MainDelegate> delegate;
@property (nonatomic, retain) UITextField *nameField;
@property (nonatomic, retain) UITextField *priceField;
@property (nonatomic, retain) UIPickerView *pickerView;
@property (nonatomic, retain) AsyncImageView *imageView;

@property (nonatomic, retain) NSString *locationName;
@property (nonatomic, retain) NSString *previousName;
@end
