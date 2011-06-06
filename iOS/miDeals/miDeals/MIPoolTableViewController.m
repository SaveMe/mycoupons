//
//  MIPoolTableViewController.m
//  miDeals
//
//  Created by User on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIPoolTableViewController.h"
#import "MICouponsTableViewController.h"
#import "MIAddCouponTableViewController.h"
#import "MICouponDetailsViewController.h"
#import "MIPoolCategoryCell.h"
#import "UIAlertView+NWToolbox.h"
#import "MIPoolDealsTableViewController.h"

@implementation MIPoolTableViewController

@synthesize connection;

#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewStyle)style {
    self = [super initWithStyle:style];
    if (self) {
        coupons = [[NSMutableArray alloc] init];
		self.title = @"Deal Pool";
    }
    return self;
}

- (void)dealloc {
    [connection release];
    [alert dismiss];
    [super dealloc];
}

- (void)addCouponService:(UIBarButtonItem*)barbuttonItem{
    MIAddCouponTableViewController* viewController = [[[MIAddCouponTableViewController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:viewController] autorelease];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    [self presentModalViewController:navController animated:YES];
}

- (void)viewDidLoad{
    [super viewDidLoad];
//    headerView.headerLabel.text = @"Deal Pool";
//	[headerView.poolButton setTitle:@"Deals" forState:UIControlStateNormal];
	[headerView.poolButton setBackgroundImage:[UIImage imageNamed:@"DealMe-My-Deals-Button.png"] forState:UIControlStateNormal];
	[headerView.poolButton addTarget:self action:@selector(dealButtonPress) forControlEvents:UIControlEventTouchUpInside];
	
    // alert = [UIAlertView showActivityAlertWithTitle:@"Getting Pool Info" message:@"Hang on..."];
    
    // self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addCouponService:)] autorelease];
}


- (void)dealButtonPress {
	[self dismissModalViewControllerAnimated:YES];

}


- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    // [self.connection fetchDealsWithDelegate:self];
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
    
    MIPoolCategoryCell *cell = (MIPoolCategoryCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MIPoolCategoryCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;   
    }
    
    // [cell configureWithCoupon:[coupons objectAtIndex:indexPath.row]];
    // Configure the cell...
	[cell configure:indexPath.row];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    MIPoolDealsTableViewController *poolDealViewController = [[MIPoolDealsTableViewController alloc] initWithStyle:UITableViewStylePlain Category:indexPath.row];
	[self.navigationController pushViewController:poolDealViewController animated:YES];
	[poolDealViewController release];
}

@end
