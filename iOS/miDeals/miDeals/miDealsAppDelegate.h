//
//  miDealsAppDelegate.h
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MILoginViewController.h"
#import "MIBackendConnection.h"

@interface miDealsAppDelegate : NSObject <UIApplicationDelegate, MILoginViewControllerDelegate> {
}
@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet MILoginViewController *viewController;
@property (nonatomic, retain) IBOutlet MIBackendConnection* connection;

@end
