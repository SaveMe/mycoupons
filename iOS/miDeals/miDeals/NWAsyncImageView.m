//
//  NWAsyncImageView.m
//  NWToolbox
//
//  Created by Martijn on 22-03-10.
//  Copyright 2010 noodlewerk.com. All rights reserved.
//

#import "NWAsyncImageView.h"
#import <QuartzCore/QuartzCore.h>

@implementation NWAsyncImageView

@synthesize asyncImage, crossFade;

#pragma mark -
#pragma mark Async Image setters

- (void)asyncImageDidFinishLoading:(NWAsyncImage*)image
{
	// Set up the fade-in animation
	CATransition *animation = [CATransition animation];
	[animation setType:kCATransitionFade];
	[animation setDuration:0.3];
	[self.layer addAnimation:animation forKey:@"fadeIn"];	
	self.image = asyncImage.image;
}

- (void)asyncImageDidLoadFromCache:(NWAsyncImage*)image
{
    self.image = asyncImage.image;
    [self setNeedsDisplay];

    if(crossFade)
    {
        CATransition *animation = [CATransition animation];
        [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
        [animation setType:kCATransitionFade];
        [animation setDuration:2.0];
        [self.layer addAnimation:animation forKey:@"CrossFade"];	
    }
}

- (void)asyncImageUsingPlaceholder:(NWAsyncImage*)image
{
	self.image = asyncImage.image;
	[self setNeedsDisplay];
}

- (void)asyncImageCancelled:(NWAsyncImage*)image
{
}



#pragma mark -
#pragma mark Object Life cycle

- (void)setup
{
	NWAsyncImage* theAsyncImage = [[NWAsyncImage alloc] init];
	theAsyncImage.delegate = self;
	self.asyncImage = theAsyncImage;
	[theAsyncImage release];
}

- (void)awakeFromNib
{
	[self setup];
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		[self setup];
	}
	return self;
}

- (void) dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	self.asyncImage.delegate = nil;
	self.asyncImage = nil;
	[super dealloc];
}



#pragma mark -
#pragma mark Public

- (void)loadImageFromURL:(NSURL *)sourceURL
{
	[self loadImageFromURL:sourceURL withPlaceHolderImage:nil];
}

- (void)loadImageFromURL:(NSURL *)sourceURL withPlaceHolderImage:(UIImage *)placeholder
{
	[asyncImage loadImageFromURL:sourceURL
					withPlaceHolderImage:placeholder];
}

- (void)loadImageFromURL:(NSURL *)sourceURL scale:(CGFloat)scale withPlaceHolderImage:(UIImage *)placeholder
{
	[asyncImage loadImageFromURL:sourceURL
												 scale:scale
					withPlaceHolderImage:placeholder];
}

@end

