//
//  MITableViewController.h
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIHeaderView.h"

@interface MITableViewController : UITableViewController {
    MIHeaderView* headerView;
}

@property int myDealCategory;

- (id)initWithStyle:(UITableViewStyle)style Category:(int)cat;

@end
