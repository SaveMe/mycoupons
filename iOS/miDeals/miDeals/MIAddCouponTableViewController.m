//
//  MIAddCouponTableViewController.m
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIAddCouponTableViewController.h"
#import "MILoginViewController.h"
#import "MIAddCouponTableViewCell.h"
#import "MIHeaderView.h"

@implementation MIAddCouponTableViewController

- (void)cancelAddCoupon:(UIBarButtonItem*)barbuttonItem{
    [self dismissModalViewControllerAnimated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    headerView.headerLabel.text = @"Add Accounts";
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelAddCoupon:)] autorelease];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    // Return the number of rows in the section.
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    MIAddCouponTableViewCell *cell = (MIAddCouponTableViewCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[MIAddCouponTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
   // cell.textLabel.text = [NSString stringWithFormat:@"Coupon Service No %i", indexPath.row];
    
    switch (indexPath.row) {
        case 2:
            cell.imageView.image = [UIImage imageNamed:@"DealMe-Boom-Logo.png"];
            break;
        case 1:
            cell.imageView.image = [UIImage imageNamed:@"DealMe-Buy-Logo.png"];
            break;
        case 0:
            cell.imageView.image = [UIImage imageNamed:@"DealMe-Groupon-Logo.png"];
            break;
        case 3:
        default:
            cell.imageView.image = [UIImage imageNamed:@"DealMe-Living-Logo.png"];
            break;
    }
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES]; 
    MILoginViewController *detailViewController = [[MILoginViewController alloc] init];
    
    switch (indexPath.row) {
        case 2:
            detailViewController.title = @"Bloomspot";
            break;
        case 1:
            detailViewController.title = @"BuyWithMe";
            break;
        case 0:
            detailViewController.title = @"Groupon";
            break;
        case 3:
        default:
            detailViewController.title = @"Livingsocial";
            break;
    }
    
    [self.navigationController pushViewController:detailViewController animated:YES];
    [detailViewController release];
}

@end
