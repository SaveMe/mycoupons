//
//  RootViewController.h
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIViewController.h"

@interface MILoginViewController : MIViewController <UITextFieldDelegate> {

    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIButton *loginButton;
    
    UIAlertView* alert;
}

- (IBAction)loginAction:(id)sender;

@end
