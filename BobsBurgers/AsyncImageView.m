//
//  AsyncImageView.m
//  BobsBurgers
//
//  Created by Robert Murphy on 10/11/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AsyncImageView.h"

@implementation AsyncImageView

- (id)init
{
    self = [super init];
    if (self) {
        self.contentMode = UIViewContentModeScaleToFill;
    }
    
    return self;
}

-(void)loadFromURLString:(NSString*)urlString {
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding]];
    ASIHTTPRequest *req = [ASIHTTPRequest requestWithURL:url];
    [req setRequestMethod:@"GET"];
    [req setDelegate:self];
    [req startAsynchronous];
}

-(void)requestFinished:(ASIHTTPRequest *)request {
    self.image = [UIImage imageWithData:[request responseData]];
    [self setNeedsLayout];
}

@end
