//
//  MIViewController.m
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIViewController.h"
#import "MIHeaderView.h"

@implementation MIViewController

- (void)__setup{
    //self.title = @"My Deals";
    UIImage* backArrowImage = [UIImage imageNamed:@"NWBackArrow.png"];
    UIBarButtonItem* barbuttonItem = [[UIBarButtonItem alloc] initWithImage:backArrowImage style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = [barbuttonItem autorelease];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self __setup];
    }
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
        [self __setup];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UIImageView* backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe-background.png"]];
    [self.view insertSubview:backImageView atIndex:0];
    [backImageView release];
}

@end
