//
//  UIAlertView+NWToolbox.m
//  NWToolbox
//
//  Created by Martijn on 20-10-09.
//  Copyright 2009 noodlewerk.com. All rights reserved.
//

#import "UIAlertView+NWToolbox.h"

@interface NWActivityAlertViewDelegate : NSObject <UIAlertViewDelegate>
{
	id cancelTarget;
	SEL cancelAction;
}
@property (nonatomic, retain) id cancelTarget;
@property (nonatomic) SEL cancelAction;
@end

@implementation NWActivityAlertViewDelegate
@synthesize cancelAction;
@synthesize cancelTarget;

- (id) init
{
	self = [super init];
	if (self != nil) { [self retain]; } // self-retain
	return self;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex  // after animatio
{
	NWActivityAlertViewDelegate* delegate = alertView.delegate;
	
	if (buttonIndex == [alertView cancelButtonIndex])
		if (delegate.cancelTarget && delegate.cancelAction && [delegate.cancelTarget respondsToSelector:delegate.cancelAction])
			[delegate.cancelTarget performSelector:delegate.cancelAction];
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex  // after animation
{
	[alertView setDelegate:nil]; // avoid the risk of getting called again, since we'll be dealloc very soon...
	[self release]; // self-release (retained in init)	
}

- (void) dealloc
{
	self.cancelTarget = nil;
	[super dealloc];
}


@end

@interface UIActivityAlertView : UIAlertView
{
	UIActivityIndicatorView* ac;
}
@end


@implementation UIActivityAlertView

- (void) dealloc
{
	[ac release]; ac = nil;
	[super dealloc];
}


- (void)layoutSubviews
{
	[super layoutSubviews];
	CGRect frame; CGRect acFrame;
	
	NSArray* subviews = [self subviews];
	UIView* firstSubview = [subviews objectAtIndex:0];
	UIView* imageView = nil;
	CGFloat lowestY = 0.0f;
	CGRect labelFrame;
	CGFloat labelBottom;
	int numButtons = [self numberOfButtons];
	
	for (UIView* label in subviews)
	{
		if ([label isKindOfClass:[UILabel class]])
		{
			labelFrame = label.frame;
			labelBottom = labelFrame.origin.y + labelFrame.size.height;
			if (labelBottom > lowestY)
				lowestY = labelBottom;
		}
		else if ([label isKindOfClass:[UIImageView class]])
		{
			if (imageView == nil)
				imageView = (UIImageView*) label;
		}
	}
	
	if (!ac)
	{
		// Add activity spinner:
		ac = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
		[ac startAnimating];
		[self addSubview: ac];
		
	}
	acFrame = [ac bounds];	
	
	// If there is a button as well, resize the alert:
	if (numButtons != 0)
	{
		// Resize the background image + the alertview (self) as well:
		
		CGFloat extraHeight = acFrame.size.height + (imageView ? -14.f : 10.f); // iOS 4.0/4.1, the alertView doesn't have an imageView
		
		frame = imageView.frame;
		frame.size.height += extraHeight;
		imageView.frame = frame;
		
		frame = self.bounds;
		frame.size.height += extraHeight;
		if (imageView) // iOS 4.0/4.1, the alertView doesn't have an imageView
			frame.origin.y -= extraHeight / 2.0f;
		self.bounds = frame;
		
		// Move the buttons down:
		for (UIView* button in subviews)
		{
			NSRange range = [NSStringFromClass([button class]) rangeOfString:@"Button"];
			if (range.location != NSNotFound)
			{
				frame = button.frame;
				frame.origin.y += acFrame.size.height + 7.f;
				button.frame = frame;
			}
		}
	}
	
	// Center the spinner:
	frame = [firstSubview frame];
	acFrame.origin.x = floorf(frame.origin.x + ((frame.size.width - acFrame.size.width) / 2.0));
	acFrame.origin.y = floorf(frame.origin.y + ((frame.size.height - acFrame.size.height) / 2.0));
	
	// Place it underneath the text:	
	acFrame.origin.y = lowestY + 14.f;
	[ac setFrame:acFrame];
}

@end


@implementation UIAlertView (NWToolbox)

+ (UIAlertView*) showBasicAlertWithTitle:(NSString*)title message:(NSString*)message
{
	UIAlertView* myAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
	[myAlert show];
	return [myAlert autorelease];
}

+ (UIAlertView*)showActivityAlertWithTitle:(NSString*)title message:(NSString*)message
{
	UIAlertView* myAlert = [[UIActivityAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:nil otherButtonTitles:nil];
	[myAlert show];
	return [myAlert autorelease];
}

+ (UIAlertView*)showActivityAlertWithTitle:(NSString*)title message:(NSString*)message withCancelButtonTitle:(NSString*)cancelButtonTitle target:(id)target action:(SEL)action
{
	NWActivityAlertViewDelegate* delegate = [[[NWActivityAlertViewDelegate alloc] init] autorelease];
	delegate.cancelTarget = target;
	delegate.cancelAction = action;
	
	UIAlertView* myAlert = [[UIActivityAlertView alloc] initWithTitle:title message:message delegate:delegate cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
	[myAlert show];
	return [myAlert autorelease];
}

- (void)dismiss
{
	[self dismissWithClickedButtonIndex:0 animated:YES];
}

@end




