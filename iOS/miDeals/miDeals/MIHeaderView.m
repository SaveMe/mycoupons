//
//  MIHeaderView.m
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIHeaderView.h"


@implementation MIHeaderView

@synthesize  headerLabel;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe-Logo-S.png"]] autorelease];
        [self addSubview:imageView];
        imageView.frame = CGRectMake(15, 2, 54, 61);
        self.headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 45)] autorelease];
        [self addSubview:headerLabel];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textAlignment = UITextAlignmentCenter;
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.numberOfLines = 0;
        headerLabel.text = @"More information";
    }
    return self;
}

- (void)dealloc
{
    self.headerLabel = nil;
    [super dealloc];
}

@end
