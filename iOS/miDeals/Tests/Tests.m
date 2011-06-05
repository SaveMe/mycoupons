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
}

- (void)loginFinished {
    
}

- (void)loginFailedWithError:(NSError *)error {
    STFail(@"login failed: %@", error);
}

- (void)fetchDealsFinishedWithDeals:(NSArray *)deals {
    
}

- (void)fetchDealsFailedWithError:(NSError *)error {
    
}

- (void)fetchDealFinishedWithDeals:(MICoupon *)deal {
    
}

- (void)fetchDealFailedWithError:(NSError *)error {
    
}

@end
