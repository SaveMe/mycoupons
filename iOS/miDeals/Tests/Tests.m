//
//  Tests.m
//  Tests
//
//  Created by Leonard on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Tests.h"
#import "MICoupon.h"

@implementation Tests

- (void)setUp {
    [super setUp];
    connection = [[MIBackendConnection connectionWithUsername:@"testuser" password:@"testpass"] retain];
}

- (void)tearDown {
    [connection release]; connection = nil;
    [super tearDown];
}

- (void)testBackend {
    [connection loginWithDelegate:self];
    while (!connection.isLoggedIn) {
        [NSThread sleepForTimeInterval:1];
        NSLog(@"waiting");
    }
}

- (void)loginFinished {
    // now fetch all deals
    [connection fetchDealsWithDelegate:self];
}

- (void)loginFailedWithError:(NSError *)error {
    STFail(@"login failed: %@", error);
}

- (void)fetchDealsFinishedWithDeals:(NSArray *)deals {
//    MICoupon *coupon = [deals objectAtIndex:0];
    NSString *dealID = @"todoID";
    [connection fetchDealWithId:dealID delegate:self];
}

- (void)fetchDealsFailedWithError:(NSError *)error {
    STFail(@"dealS failed: %@", error);
}

- (void)fetchDealFinishedWithDeals:(MICoupon *)deal {
    STAssertNotNil(deal, @"deal not properly fetched");
    // TODO logout
}

- (void)fetchDealFailedWithError:(NSError *)error {
    STFail(@"deal failed: %@", error);
}

@end
