//
//  MIAddCouponTableViewCell.m
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIAddCouponTableViewCell.h"


@implementation MIAddCouponTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe-+-icon.png"]] autorelease];

    }
    return self;
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    self.imageView.alpha = highlighted ? 0.5 : 1.0;
    self.textLabel.textColor = highlighted ? [UIColor whiteColor] : [UIColor lightGrayColor];
    self.backgroundColor = highlighted ? [UIColor colorWithWhite:0 alpha:0.6] : [UIColor colorWithWhite:0 alpha:0.35];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self setHighlighted:selected animated:animated];
}

- (void)dealloc
{
    [super dealloc];
}

@end
