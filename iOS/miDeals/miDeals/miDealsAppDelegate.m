//
//  miDealsAppDelegate.m
//  miDeals
//
//  Created by Jorn van Dijk on 04-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "miDealsAppDelegate.h"
#import "MIViewController.h"
#import "MICouponsTableViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MIBackendConnection.h"


@implementation miDealsAppDelegate


@synthesize window=_window, connection=_connection;

@synthesize viewController;

- (void)loginViewController:(MILoginViewController*)vc didFinishWithConnection:(MIBackendConnection*)theConnection{
 
    self.connection = theConnection;

    MICouponsTableViewController* aViewController = [[[MICouponsTableViewController alloc] initWithStyle:UITableViewStylePlain Category:-1] autorelease];
    aViewController.connection = theConnection;
    UINavigationController* navController = [[[UINavigationController alloc] initWithRootViewController:aViewController] autorelease];
    navController.navigationBar.barStyle = UIBarStyleBlack;
    self.window.rootViewController = navController;
    CATransition* fade = [CATransition animation];
    fade.type = kCATransitionFade;
    [self.window.layer addAnimation:fade forKey:nil];
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    viewController.delegate = self;
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_connection release];
    [_window release];
    [viewController release];
    [super dealloc];
}


@end
