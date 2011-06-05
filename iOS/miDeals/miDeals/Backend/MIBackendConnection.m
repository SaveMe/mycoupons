//
//  BackendConnection.m
//  miDeals
//
//  Created by Leonard on 6/4/11.
//  Copyright 2011 SnikkelSoft. All rights reserved.
//

#import "MIBackendConnection.h"
#import "GDataHTTPFetcher.h"

#define SERVER_URL @"http://mycoupons.heroku.com/"

@implementation MIBackendConnection

- (id)initWithUsername:(NSString *)_username password:(NSString *)_password {
    self = [super init];
    if (self) {
        username = [_username retain];
        password = [_password retain];
    }
    return self;
}

+ (id)connectionWithUsername:(NSString *)username password:(NSString *)password {
    return [[[self alloc] initWithUsername:username password:password] autorelease];
}

- (void)dealloc {
    [username release];
    [password release];
    [super dealloc];
}

- (BOOL)parseLoginResponseData:(NSData *)data error:(NSError **)error {
    // TODO
    return NO;
}

- (NSArray *)parseDealsResponseData:(NSData *)data error:(NSError **)error {
    // TODO
    return NO;
}


- (void)loginWithDelegate:(id<MILoginDelegate>)delegate {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SERVER_URL "sign_in"]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    [request setValue:username forHTTPHeaderField:@"username"];
    [request setValue:password forHTTPHeaderField:@"password"];
    GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (!data) {
            [delegate loginFailedWithError:error];
        }
        NSError *parseError = nil;
        if (![self parseLoginResponseData:data error:&parseError]) {
            [delegate loginFailedWithError:parseError];            
        }
        [delegate loginFinished];
    }];
}

- (void)fetchDealsWithDelegate:(id<MIFetchDealsDelegate>)delegate {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SERVER_URL "deals"]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    [request setValue:username forHTTPHeaderField:@"username"];
    [request setValue:password forHTTPHeaderField:@"password"];
    GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (!data) {
            [delegate fetchDealsFailedWithError:error];
        }
        NSError *parseError = nil;
        NSArray *deals = [self parseDealsResponseData:data error:&parseError];
        if (!deals) {
            [delegate fetchDealsFailedWithError:parseError];            
        }
        [delegate fetchDealsFinishedWithDeals:deals];
    }];    
}

- (void)fetchDealWithId:(NSString *)dealId delegate:(id<MIFetchDealsDelegate>)delegate {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SERVER_URL "deals"]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    [request setValue:username forHTTPHeaderField:@"username"];
    [request setValue:password forHTTPHeaderField:@"password"];
    GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (!data) {
            [delegate fetchDealsFailedWithError:error];
        }
        NSError *parseError = nil;
        NSArray *deals = [self parseDealsResponseData:data error:&parseError];
        if (!deals) {
            [delegate fetchDealsFailedWithError:parseError];            
        }
        [delegate fetchDealsFinishedWithDeals:deals];
    }];    
}

@end
