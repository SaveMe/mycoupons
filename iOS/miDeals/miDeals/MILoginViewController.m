//
//  RootViewController.m
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MILoginViewController.h"
#import "UIAlertView+NWToolbox.h"
#import "MICouponsTableViewController.h"

@implementation MILoginViewController

- (void)shouldLogin{
    // TODO login request
    [self performSelector:@selector(didLogin) withObject:nil afterDelay:0.5];
}

- (void)didLogin{
    [alert dismiss]; alert = nil;
    MICouponsTableViewController* viewController = [[MICouponsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController pushViewController:viewController animated:YES];
    [viewController release];
}


- (void)cancelLogin{
    [alert dismiss]; alert = nil;
}

- (IBAction)loginAction:(id)sender {
    alert = [UIAlertView showActivityAlertWithTitle:@"Logging in" message:@"Please wait..." withCancelButtonTitle:@"Cancel" target:self action:@selector(cancelLogin)];
    [self shouldLogin];
}

- (void)viewDidLoad{
    [usernameTextField becomeFirstResponder];
}

- (void)dealloc {
    [loginButton release];
    [usernameTextField release];
    [passwordTextField release];
    [super dealloc];
}

- (void)viewDidUnload {
    [loginButton release];
    loginButton = nil;
    [usernameTextField release];
    usernameTextField = nil;
    [passwordTextField release];
    passwordTextField = nil;
   [super viewDidUnload];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(textField == usernameTextField){
        [passwordTextField becomeFirstResponder];
    } else if(textField == passwordTextField){
        [self loginAction:loginButton];
    }
    return YES;
}


@end
