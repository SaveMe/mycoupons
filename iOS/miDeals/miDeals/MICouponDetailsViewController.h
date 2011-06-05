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
}

@property (nonatomic, retain) MICoupon* coupon;
- (id)initWithCoupon:(MICoupon *)_coupon;


@end
