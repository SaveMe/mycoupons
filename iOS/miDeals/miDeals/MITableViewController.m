//
//  MITableViewController.m
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MITableViewController.h"
#import "MIHeaderView.h"

@implementation MITableViewController

@synthesize myDealCategory;

- (void)__setup{
    // self.title = @"My Deals";
    UIImage* backArrowImage = [UIImage imageNamed:@"NWBackArrow.png"];
    UIBarButtonItem* barbuttonItem = [[UIBarButtonItem alloc] initWithImage:backArrowImage style:UIBarButtonItemStyleBordered target:nil action:nil];
    self.navigationItem.backBarButtonItem = [barbuttonItem autorelease];
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self __setup];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style Category:(int)cat {
    self = [super initWithStyle:style];
    if (self) {
		myDealCategory = cat;
		switch (cat) {
			case -1:
				self.title = @"My Deals";
				break;
			case -2:
				self.title = @"Deal Pool";
				break;
		}
        [self __setup];
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];

    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView* backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe-background.png"]];
    self.tableView.backgroundView = backImageView;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.28];
    [backImageView release];
	
	if (myDealCategory < 0) {
      headerView = [[[MIHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)] autorelease];
      self.tableView.tableHeaderView = headerView;
	}
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 94;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    cell.backgroundColor = [UIColor colorWithWhite:0 alpha:0.35];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}

@end
