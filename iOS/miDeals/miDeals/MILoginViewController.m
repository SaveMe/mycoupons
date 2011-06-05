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
@synthesize delegate, connection;

- (BOOL)shouldLogin:(NSString**)problem {
    if ([[usernameTextField text] isEqualToString:@""] || [usernameTextField text] == nil) {
        *problem = @"Can't go anonymous!!";
        [usernameTextField becomeFirstResponder];
        return NO;
    } else if ([[passwordTextField text] isEqualToString:@""] || [passwordTextField text] == nil) {
        *problem = @"What's the password?";
        [passwordTextField becomeFirstResponder];
        return NO;
    }
    return YES;
}

- (IBAction)loginAction:(id)sender {
    NSAssert(alert == nil, @"whoops already loggin in?");
    if (alert)
        return;
    
    NSAssert(connection == nil, @"whoops connection already created?");
    if (connection)
        return;
    
    NSString* problem = nil;
    BOOL shouldLogin = [self shouldLogin:&problem];
    if (shouldLogin) {
        connection = [[MIBackendConnection alloc] initWithUsername:usernameTextField.text password:passwordTextField.text];
        alert = [UIAlertView showActivityAlertWithTitle:@"Logging in" message:@"Hang on..."];
    } else {
        [UIAlertView showBasicAlertWithTitle:nil message:problem];
    }
}

- (void)viewDidLoad{
    [super viewDidLoad];
    [usernameTextField becomeFirstResponder];
}

- (void)dealloc {
    [loginButton release];
    [usernameTextField release];
    [passwordTextField release];
    [problemLabel release];
    [connection release]; connection = nil;
    [super dealloc];
}

- (void)viewDidUnload {
    [loginButton release];
    loginButton = nil;
    [usernameTextField release];
    usernameTextField = nil;
    [passwordTextField release];
    passwordTextField = nil;
    [problemLabel release];
    problemLabel = nil;
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


#pragma mark -
#pragma mark MILoginDelegate

- (void)loginFinished {
    [alert dismiss]; alert = nil;
    MICouponsTableViewController* viewController = [[MICouponsTableViewController alloc] initWithStyle:UITableViewStylePlain];
    [self.navigationController setViewControllers:[NSArray arrayWithObject:viewController] animated:YES];
    [viewController release];
}

- (void)loginFailedWithError:(NSError*)error {
    [alert dismiss]; alert = nil;
    [UIAlertView showBasicAlertWithTitle:@"Whoops!" message:[error localizedDescription]];
}

@end
