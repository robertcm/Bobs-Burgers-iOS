//
//  AsyncImageView.h
//  BobsBurgers
//
//  Created by Robert Murphy on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface AsyncImageView : UIImageView<ASIHTTPRequestDelegate>

-(void)loadFromURLString:(NSString*)urlString;

@end
