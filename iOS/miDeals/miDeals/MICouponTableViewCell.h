//
//  MICouponTableViewCell.h
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NWAsyncImageView.h"

@class MICoupon;

@interface MICouponTableViewCell : UITableViewCell {
    NWAsyncImageView* asyncImageView;
}

- (void)configureWithCoupon:(MICoupon*)coupon;

@end
