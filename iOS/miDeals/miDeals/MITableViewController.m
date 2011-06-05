//
//  MITableViewController.m
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MITableViewController.h"


@implementation MITableViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.title = @"Deal Me";
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView* backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe-background.png"]];
    self.tableView.backgroundView = backImageView;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.28];
    [backImageView release];
    
    UIView* headerView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 65)] autorelease];
    UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe-Logo-S.png"]] autorelease];
    [headerView addSubview:imageView];
    imageView.frame = CGRectMake(15, 2, 54, 61);
    headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 45)] autorelease];
    [headerView addSubview:headerLabel];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.textAlignment = UITextAlignmentCenter;
    headerLabel.textColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:14];
    headerLabel.numberOfLines = 0;
    headerLabel.text = @"More information";
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
