//
//  Tests.h
//  Tests
//
//  Created by Leonard on 6/4/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>
#import "MIBackendConnection.h"

@interface Tests : SenTestCase<MILoginDelegate, MIFetchDealsDelegate, MIFetchDealDelegate> {
@private
    MIBackendConnection *connection;
}

@end
