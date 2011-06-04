//
//  MICouponTableViewCell.m
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MICouponTableViewCell.h"
#import "MICoupon.h"

@implementation MICouponTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        asyncImageView = [[NWAsyncImageView alloc] init];
        [self.contentView addSubview:asyncImageView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.textLabel.textColor = [UIColor whiteColor];
        self.textLabel.textColor = [UIColor lightGrayColor];
        self.textLabel.font = [UIFont boldSystemFontOfSize:14];
        self.textLabel.numberOfLines = 0;
        self.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe->-icon.png"]] autorelease];
        
        self.detailTextLabel.textColor = [UIColor lightGrayColor];
        self.detailTextLabel.numberOfLines = 0;
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    asyncImageView.frame = CGRectMake(10, 19, 92, 58);
    self.textLabel.frame = CGRectMake(112, 19, self.contentView.frame.size.width - 120, 32);
    self.detailTextLabel.frame = CGRectMake(112, 56, self.contentView.frame.size.width - 120, self.contentView.frame.size.height - 60);
}

- (void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated{
    [super setHighlighted:highlighted animated:animated];
    asyncImageView.alpha = highlighted ? 0.5 : 1.0;
    self.textLabel.textColor = highlighted ? [UIColor whiteColor] : [UIColor lightGrayColor];
    self.backgroundColor = highlighted ? [UIColor colorWithWhite:0 alpha:0.6] : [UIColor colorWithWhite:0 alpha:0.35];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [self setHighlighted:selected animated:animated];
}

- (void)dealloc {
    [asyncImageView release];
    [super dealloc];
}

- (void)configureWithCoupon:(MICoupon *)coupon{
    NSURL* url = [NSURL URLWithString:coupon.imageURLString];
    [asyncImageView loadImageFromURL:url  withPlaceHolderImage:[UIImage imageNamed:@"DealMe-Placeholder.png"]];
    self.detailTextLabel.text = @"Blablasfas";
}

@end
