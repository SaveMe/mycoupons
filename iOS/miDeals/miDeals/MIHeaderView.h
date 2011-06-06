//
//  MIHeaderView.h
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MIHeaderView : UIView {
	NSTimer *tokenUpdateTimer;
}

//@property (nonatomic, retain) UILabel* headerLabel;
@property (nonatomic, retain) UILabel* tokenCountLabel;
@property (nonatomic, retain) UIButton* poolButton;

@end
