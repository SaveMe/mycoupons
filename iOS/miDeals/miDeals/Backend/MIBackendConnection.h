//
//  BackendConnection.h
//  miDeals
//
//  Created by Leonard on 6/4/11.
//  Copyright 2011 SnikkelSoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MICoupon;
@protocol MILoginDelegate, MIFetchDealsDelegate, MIFetchDealDelegate;

@interface MIBackendConnection : NSObject {
@private
    NSString *username;
    NSString *password;
    NSString *sessionID;
}
@property (readonly) BOOL isLoggedIn;
- (id)initWithUsername:(NSString *)username password:(NSString *)password;
+ (id)connectionWithUsername:(NSString *)username password:(NSString *)password;
- (void)loginWithDelegate:(id<MILoginDelegate>)delegate;
- (void)fetchDealsWithDelegate:(id<MIFetchDealsDelegate>)delegate;
- (void)fetchDealWithId:(NSString *)dealId delegate:(id<MIFetchDealsDelegate>)delegate;
@end

@protocol MILoginDelegate <NSObject>
- (void)loginFinished;
- (void)loginFailedWithError:(NSError *)error;
@end

@protocol MIFetchDealsDelegate <NSObject>
- (void)fetchDealsFinishedWithDeals:(NSArray *)deals;
- (void)fetchDealsFailedWithError:(NSError *)error;
@end

@protocol MIFetchDealDelegate <NSObject>
- (void)fetchDealFinishedWithDeals:(MICoupon *)deal;
- (void)fetchDealFailedWithError:(NSError *)error;
@end
