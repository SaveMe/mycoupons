//
//  UIAlertView+NWToolbox.h
//  NWToolbox
//
//  Created by Martijn on 20-10-09.
//  Copyright 2009 noodlewerk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UIAlertView (NWToolbox)
+ (UIAlertView*)showBasicAlertWithTitle:(NSString*)title message:(NSString*)message;
+ (UIAlertView*)showActivityAlertWithTitle:(NSString*)title message:(NSString*)message;
+ (UIAlertView*)showActivityAlertWithTitle:(NSString*)title message:(NSString*)message withCancelButtonTitle:(NSString*)cancelButtonTitle target:(id)target action:(SEL)action;
- (void)dismiss;
@end
