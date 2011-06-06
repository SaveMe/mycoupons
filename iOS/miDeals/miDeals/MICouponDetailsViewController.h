//
//  MICouponDetailsViewController.h
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIViewController.h"
#import "NWAsyncImageView.h"
#import "MICoupon.h"

@interface MICouponDetailsViewController : MIViewController {
    IBOutlet UIScrollView *scrollView;
    IBOutlet UILabel *dateLabel;
    IBOutlet NWAsyncImageView *asyncImage;
    IBOutlet UILabel *priceLabel;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *descriptionLabel;
    IBOutlet NWAsyncImageView *couponCodeImageView;
    IBOutlet UILabel *couponCodeLabel;

	IBOutlet UIButton *lockButton;
	IBOutlet UIButton *donateButton;
	
	UINavigationController *navCtrl;
}

@property (nonatomic, retain) MICoupon* coupon;
- (id)initWithCoupon:(MICoupon *)_coupon NavController:(UINavigationController *)_navCtrl;
-(IBAction)lockButtonPress:(id)sender;
-(IBAction)donateButtonPress:(id)sender;

@end
