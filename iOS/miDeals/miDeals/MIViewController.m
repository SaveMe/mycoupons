//
//  MIViewController.m
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIViewController.h"


@implementation MIViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    UIImageView* backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe-background.png"]];
    [self.view insertSubview:backImageView atIndex:0];
    [backImageView release];
}

@end
