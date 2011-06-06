//
//  MIHeaderView.m
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIHeaderView.h"
#import "MIGeneric.h"

@implementation MIHeaderView

//@synthesize  headerLabel;
@synthesize tokenCountLabel;
@synthesize poolButton;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView* imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe-Logo-S.png"]] autorelease];
        [self addSubview:imageView];
        imageView.frame = CGRectMake(15, 2, 54, 61);
		
#if 0
        self.headerLabel = [[[UILabel alloc] initWithFrame:CGRectMake(60, 10, 200, 45)] autorelease];
        [self addSubview:headerLabel];
        headerLabel.backgroundColor = [UIColor clearColor];
        headerLabel.textAlignment = UITextAlignmentCenter;
        headerLabel.textColor = [UIColor whiteColor];
        headerLabel.font = [UIFont boldSystemFontOfSize:14];
        headerLabel.numberOfLines = 0;
        headerLabel.text = @"More information";
#endif
		float scale = 0.5;
		float w = 153*scale;
		float h = 67*scale;
        imageView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe-Token.png"]] autorelease];
        [self addSubview:imageView];
        imageView.frame = CGRectMake(320-w-12, 15, w, h);

		self.tokenCountLabel = [[[UILabel alloc] initWithFrame:CGRectMake(320-(w/2)-16, 13, w/2, h)] autorelease];
        [self addSubview:tokenCountLabel];
        tokenCountLabel.backgroundColor = [UIColor clearColor];
        tokenCountLabel.textAlignment = UITextAlignmentCenter;
        tokenCountLabel.textColor = [UIColor blackColor];
        tokenCountLabel.font = [UIFont boldSystemFontOfSize:14];
        tokenCountLabel.numberOfLines = 0;
        tokenCountLabel.text = [NSString stringWithFormat:@"%d", nrOfTokensHack];
		
		self.poolButton = [[[UIButton alloc] initWithFrame:CGRectMake(112, 15, w, h)] autorelease];
        [self addSubview:poolButton];

		tokenUpdateTimer = [NSTimer scheduledTimerWithTimeInterval:(NSTimeInterval)1.0
													  target:self selector:@selector(tokenUpdateTimerTimeout) userInfo:nil repeats:YES];

	
	}
    return self;
}

-(void)tokenUpdateTimerTimeout {
	tokenCountLabel.text = [NSString stringWithFormat:@"%d", nrOfTokensHack];
}


- (void)dealloc
{
    //self.headerLabel = nil;
    self.tokenCountLabel = nil;
    self.poolButton = nil;
	[tokenUpdateTimer invalidate];
    [super dealloc];
}

@end
