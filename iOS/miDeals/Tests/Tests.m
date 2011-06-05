//
//  Tests.m
//  Tests
//
//  Created by Leonard on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Tests.h"

@implementation Tests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testBackend {
    MIBackendConnection *connection = [MIBackendConnection connectionWithUsername:@"testuser" password:@"testpass"];
    [connection loginWithDelegate:self];
    [connection fetchDealsWithDelegate:self];
    [connection fetchDealsWithDelegate:self];
}

- (void)loginFinished {
    
}

- (void)loginFailedWithError:(NSError *)error {
    STFail(@"login failed: %@", error);
}

- (void)fetchDealsFinishedWithDeals:(NSArray *)deals {
    
}

- (void)fetchDealsFailedWithError:(NSError *)error {
    STFail(@"dealS failed: %@", error);
}

- (void)fetchDealFinishedWithDeals:(MICoupon *)deal {
    
}

- (void)fetchDealFailedWithError:(NSError *)error {
    STFail(@"deal failed: %@", error);
}

@end
