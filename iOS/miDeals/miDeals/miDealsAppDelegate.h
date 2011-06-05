//
//  miDealsAppDelegate.h
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBackendConnection.h"
#import "MILoginViewController.h"

@interface miDealsAppDelegate : NSObject <UIApplicationDelegate, MILoginViewControllerDelegate> {

}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;
@property (nonatomic, retain) IBOutlet MIBackendConnection* connection;

@end
