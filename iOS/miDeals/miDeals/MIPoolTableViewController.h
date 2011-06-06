//
//  MIPoolTableViewController.h
//  miDeals
//
//  Created by User on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MITableViewController.h"
#import "MIBackendConnection.h"


@interface MIPoolTableViewController : MITableViewController  {
    MIBackendConnection *connection;
    NSArray* coupons;
    UIAlertView *alert;	
}

@property (nonatomic, retain) MIBackendConnection *connection;

@end


