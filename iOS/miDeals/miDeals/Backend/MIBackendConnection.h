//
//  BackendConnection.h
//  miDeals
//
//  Created by Leonard on 6/4/11.
//  Copyright 2011 SnikkelSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MIBackendConnection : NSObject {
@private
    NSString *username;
    NSString *password;
}
- (id)initWithUsername:(NSString *)username password:(NSString *)password;
+ (id)connectionWithUsername:(NSString *)username password:(NSString *)password;
@end

@protocol MILoginDelegate <NSObject>
- (void)loginFinished;
- (void)loginFailedWithError:(NSError *)error;
@end

@protocol MIFetchDealsDelegate <NSObject>
- (void)setDeals:(NSArray *)deals;
@end