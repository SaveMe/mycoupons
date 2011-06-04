//
//  MICouponDetailsViewController.m
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MICouponDetailsViewController.h"


@implementation MICouponDetailsViewController

@synthesize coupon;
#pragma mark - View lifecycle

- (id)initWithCoupon:(MICoupon *)_coupon {
    self = [super init];
    if (self) {
        self.coupon = _coupon;
    }
    return self;
}

- (void)dealloc {
    self.coupon = nil;
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    asyncImage = [[NWAsyncImageView alloc] init];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
