//
//  WelcomeViewController.h
//  BobsBurgers
//
//  Created by Robert Murphy on 10/10/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainDelegate.h"

@interface WelcomeViewController : UIViewController<UITextFieldDelegate> {
    id<MainDelegate> delegate;
    
    UITextField *textField;
}

@property (nonatomic, assign) id<MainDelegate> delegate;

@end
