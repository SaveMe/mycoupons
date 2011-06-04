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
    self.tableView.backgroundColor = [UIColor clearColor];
    UIImageView* backImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe-background.png"]];
    self.tableView.backgroundView = backImageView;
    self.tableView.separatorColor = [UIColor colorWithWhite:1 alpha:0.28];
    [backImageView release];
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
