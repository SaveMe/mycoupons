//
//  MICouponDetailsViewController.m
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MICouponDetailsViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MIHeaderView.h"
#import "MIGeneric.h"

@implementation MICouponDetailsViewController

@synthesize coupon;
#pragma mark - View lifecycle

- (id)initWithCoupon:(MICoupon *)_coupon NavController:(UINavigationController *)_navCtrl {
    self = [super init];
    if (self) {
        self.coupon = _coupon;
		navCtrl = _navCtrl;
    }
    return self;
}

- (void)dealloc {
    self.coupon = nil;
    [scrollView release];
    [asyncImage release];
    [titleLabel release];
    [descriptionLabel release];
    [dateLabel release];
    [priceLabel release];
    [couponCodeImageView release];
    [couponCodeLabel release];
    [super dealloc];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    MIHeaderView* headerView = [[[MIHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)] autorelease];
    [self.view addSubview:headerView];
    //headerView.headerLabel.text = @"";
    
    scrollView.layer.borderColor = [[UIColor colorWithWhite:1 alpha:0.28] CGColor];
    scrollView.layer.borderWidth = 1.0;
    
    
    NSURL* url = [NSURL URLWithString:coupon.imageURLString];
    [asyncImage loadImageFromURL:url withPlaceHolderImage:[UIImage imageNamed:PlaceHolderImageName(coupon.title)]];
    NSURL* barcodeurl = [NSURL URLWithString:coupon.imageURLString];
    [couponCodeImageView loadImageFromURL:barcodeurl withPlaceHolderImage:[UIImage imageNamed:@"DealMe-Barcode.png"]];

    if(coupon){
        titleLabel.text = coupon.title;
        descriptionLabel.text = coupon.desc;
		if (coupon.locked == nil) coupon.locked = [NSNumber numberWithBool:NO];
		if (coupon.locked.boolValue) {
			[lockButton setImage:[UIImage imageNamed:@"DealMe-UnLock-Button.png"] forState:UIControlStateNormal];
		}
    }
}

- (void)viewDidUnload {
    [scrollView release];
    scrollView = nil;
    [asyncImage release];
    asyncImage = nil;
    [titleLabel release];
    titleLabel = nil;
    [descriptionLabel release];
    descriptionLabel = nil;
    [dateLabel release];
    dateLabel = nil;
    [priceLabel release];
    priceLabel = nil;
    [couponCodeImageView release];
    couponCodeImageView = nil;
    [couponCodeLabel release];
    couponCodeLabel = nil;
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)lockButtonPress:(id)sender {
	if (coupon == nil) return;
	if (coupon.locked.boolValue) {
		coupon.locked = [NSNumber numberWithBool:NO];
		 [lockButton setImage:[UIImage imageNamed:@"DealMe-Lock-Button.png"] forState:UIControlStateNormal];
	} else {
		coupon.locked = [NSNumber numberWithBool:YES];
		[lockButton setImage:[UIImage imageNamed:@"DealMe-UnLock-Button.png"] forState:UIControlStateNormal];
	}
}

-(IBAction)donateButtonPress:(id)sender {
	nrOfTokensHack++;
	[navCtrl popViewControllerAnimated:YES];
}


@end
