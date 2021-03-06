//
//  MICoupon.h
//  miDeals
//
//  Created by Jorn van Dijk on 05-06-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MICoupon : NSObject {
    NSString* imageURLString;
    NSString* title;
    NSString* subtitle;
    NSDate* expirationDate;
    NSString* desc;
    NSNumber* price;
	NSNumber* locked;
}

@property (nonatomic, retain) NSString* imageURLString;
@property (nonatomic, retain) NSString* title;
@property (nonatomic, retain) NSString* subtitle;
@property (nonatomic, retain) NSDate* expirationDate;
@property (nonatomic, retain) NSString* desc;
@property (nonatomic, retain) NSNumber* price;
@property (nonatomic, retain) NSNumber* locked;

@end
