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


- (void)__setup{
    self.title = @"Deal Me";
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

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
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
    
    headerView = [[[MIHeaderView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)] autorelease];
    self.tableView.tableHeaderView = headerView;
    
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
