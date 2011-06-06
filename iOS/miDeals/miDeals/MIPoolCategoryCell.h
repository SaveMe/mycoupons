//
//  MIPoolCategoryCell.h
//  miDeals
//
//  Created by User on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWAsyncImageView.h"


@interface MIPoolCategoryCell : UITableViewCell {

    NWAsyncImageView* asyncImageView;
    UILabel* dateLabel;
}

-(void)configure:(int)nr;

@end
