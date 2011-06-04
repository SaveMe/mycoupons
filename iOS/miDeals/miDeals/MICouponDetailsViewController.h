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
    NWAsyncImageView* asyncImage;
}

@property (nonatomic, retain) MICoupon* coupon;

@end
