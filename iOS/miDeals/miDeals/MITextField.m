//
//  MITextField.m
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MITextField.h"


@implementation MITextField

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    }
    return self;
}

- (CGRect) editingRectForBounds:(CGRect)bounds{
    CGRect theRect = CGRectMake(10, 0, self.bounds.size.width - 20, self.bounds.size.height);
    return theRect;
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    CGRect theRect = CGRectMake(10, 0, 165, 100);
    return theRect;
}


@end
