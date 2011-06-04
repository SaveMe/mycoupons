//
//  MICouponsTableViewController.m
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MICouponsTableViewController.h"
#import "MIAddCouponTableViewController.h"
#import "MICouponDetailsViewController.h"
#import "MICouponTableViewCell.h"

@implementation MICouponsTableViewController

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
    }
    return self;
}

- (void)addCouponService:(UIBarButtonItem*)barbuttonItem{
    MIAddCouponTableViewController* viewController = [[[MIAddCouponTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    [self presentModalViewController:navController animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    headerLabel.text = @"My Deals";
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCouponService:)] autorelease];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    MICouponTableViewCell *cell = (MICouponTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MICouponTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
    }
    
    [cell configureWithCoupon:nil];
    // Configure the cell...
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
     MICouponDetailsViewController *detailViewController = [[MICouponDetailsViewController alloc] init];
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
}

@end
