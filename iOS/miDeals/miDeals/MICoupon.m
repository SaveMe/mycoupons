//
//  MICoupon.m
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MICoupon.h"


@implementation MICoupon

@synthesize imageURLString, title, subtitle, expirationDate, desc, price, locked;

- (void)dealloc {
    [imageURLString release];
    [title release];
    [subtitle release];
    [expirationDate release];
    [desc release];
    [price release];
	[locked release];
    
    [super dealloc];
}

@end
