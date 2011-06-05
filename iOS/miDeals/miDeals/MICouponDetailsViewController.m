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
    [scrollView release];
    [asyncImage release];
    [titleLabel release];
    [subTitleLabel release];
    [descriptionLabel release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    scrollView.contentSize = CGSizeMake(320, 600);

    NSURL* url = [NSURL URLWithString:coupon.imageURLString];
    [asyncImage loadImageFromURL:url withPlaceHolderImage:[UIImage imageNamed:@"DealMe-Placeholder.png"]];
    if(coupon){
        titleLabel.text = coupon.title;
        subTitleLabel.text = coupon.subtitle;
        descriptionLabel.text = coupon.desc;
    }
}

- (void)viewDidUnload {
    [scrollView release];
    scrollView = nil;
    [asyncImage release];
    asyncImage = nil;
    [titleLabel release];
    titleLabel = nil;
    [subTitleLabel release];
    subTitleLabel = nil;
    [descriptionLabel release];
    descriptionLabel = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
