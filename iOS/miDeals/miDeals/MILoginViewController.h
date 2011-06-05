//
//  RootViewController.h
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBackendConnection.h"

@protocol MILoginViewControllerDelegate;

@interface MILoginViewController : UIViewController <UITextFieldDelegate, MILoginDelegate> {

    IBOutlet UILabel *problemLabel;
    IBOutlet UITextField *usernameTextField;
    IBOutlet UITextField *passwordTextField;
    IBOutlet UIButton *loginButton;
    UIAlertView* alert;
    
    IBOutlet UIScrollView *scrollView;
    MIBackendConnection* connection;
}
@property (nonatomic, assign) id <MILoginViewControllerDelegate> delegate;
@property (nonatomic, readonly) MIBackendConnection* connection;

- (IBAction)loginAction:(id)sender;

@end


@protocol MILoginViewControllerDelegate <NSObject>
- (void)loginViewController:(MILoginViewController*)vc didFinishWithConnection:(MIBackendConnection*)connection;
@end