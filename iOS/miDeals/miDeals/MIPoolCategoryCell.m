//
//  MIPoolCategoryCell.m
//  miDeals
//
//  Created by User on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIPoolCategoryCell.h"

@implementation MIPoolCategoryCell

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
        self.textLabel.numberOfLines = 1;
        self.accessoryView = [[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"DealMe->-icon.png"]] autorelease];
        
        self.detailTextLabel.textColor = [UIColor whiteColor];
        self.detailTextLabel.numberOfLines = 1;
        self.detailTextLabel.font = [UIFont systemFontOfSize:12];
        
        dateLabel = [[[UILabel alloc] initWithFrame:CGRectZero] autorelease];
        dateLabel.font = [UIFont italicSystemFontOfSize:12];
        dateLabel.textColor = [UIColor whiteColor];
        dateLabel.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:dateLabel];
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    asyncImageView.frame = CGRectMake(10, 19, 64, 65);
    self.textLabel.frame = CGRectMake(112, 40, self.contentView.frame.size.width - 120, 15);
	
	//  CGSize size = [self.detailTextLabel.text sizeWithFont:[self.detailTextLabel font] constrainedToSize:CGSizeMake(self.contentView.frame.size.width - 120, self.contentView.frame.size.height - 60)];
    self.detailTextLabel.frame = CGRectMake(112, 40, self.contentView.frame.size.width - 120, 15);
    dateLabel.frame = CGRectMake(112, 60, self.contentView.frame.size.width - 120, 15);
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

-(void)configure:(int)nr {
	NSURL* url;
	switch (nr) {
		case 0:
			url = [NSURL URLWithString:@""];
			[asyncImageView loadImageFromURL:url  withPlaceHolderImage:[UIImage imageNamed:@"DealMe-Pool-coffee.png"]];
			self.textLabel.text = @"Coffee";
			break;
		case 1:
			url = [NSURL URLWithString:@""];
			[asyncImageView loadImageFromURL:url  withPlaceHolderImage:[UIImage imageNamed:@"DealMe-Pool-drink.png"]];
			self.textLabel.text = @"Drink";
			break;
		case 2:
			url = [NSURL URLWithString:@""];
			[asyncImageView loadImageFromURL:url  withPlaceHolderImage:[UIImage imageNamed:@"DealMe-Pool-scape.png"]];
			self.textLabel.text = @"Escape";
			break;
		default:
			url = [NSURL URLWithString:@""];
			[asyncImageView loadImageFromURL:url  withPlaceHolderImage:[UIImage imageNamed:@"DealMe-Pool-restaurant.png"]];
			self.textLabel.text = @"Restaurant";
			break;
	}
    self.detailTextLabel.text = @"";
    // dateLabel.text = [[MICouponTableViewCell dateFormatter] stringFromDate:coupon.expirationDate]; 
}

@end
