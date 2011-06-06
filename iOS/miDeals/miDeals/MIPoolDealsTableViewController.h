//
//  MIPoolDealsTableViewController.h
//  miDeals
//
//  Created by User on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MIBackendConnection.h"
#import "MITableViewController.h"

@interface MIPoolDealsTableViewController : MITableViewController {
    MIBackendConnection *connection;
    NSMutableArray* coupons;
    UIAlertView *alert;
}

-(id)initWithStyle:(UITableViewStyle)style Category:(int)cat;

@property (nonatomic, retain) MIBackendConnection *connection;

@end


