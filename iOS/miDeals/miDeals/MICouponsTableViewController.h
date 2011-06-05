//
//  MICouponsTableViewController.h
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MITableViewController.h"
#import "MIBackendConnection.h"

@interface MICouponsTableViewController : MITableViewController <MIFetchDealsDelegate> {
    MIBackendConnection *connection;
    NSArray* coupons;
    UIAlertView *alert;
}

@property (nonatomic, retain) MIBackendConnection *connection;

@end
