//
//  MICoupon.m
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MICoupon.h"


@implementation MICoupon

@synthesize imageURLString;

- (void)dealloc {
    self.imageURLString = nil;
    [super dealloc];
}

@end