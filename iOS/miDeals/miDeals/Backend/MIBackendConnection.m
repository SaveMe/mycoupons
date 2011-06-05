//
//  BackendConnection.m
//  miDeals
//
//  Created by Leonard on 6/4/11.
//  Copyright 2011 SnikkelSoft. All rights reserved.
//

#import "MIBackendConnection.h"
#import "GDataHTTPFetcher.h"
#import "JSONKit.h"
#import "MICoupon.h"

#define SERVER_URL @"http://mycoupons.heroku.com/"

#define DDErrorAssign(__description, ...) {if (error) {*error = [NSError errorWithDomain:@"mi" code:0 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:(__description),##__VA_ARGS__,@""],NSLocalizedDescriptionKey,nil]];}}

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

- (MICoupon *)parseDealJson:(NSDictionary *)dict {
    MICoupon *result = [[[MICoupon alloc] init] autorelease];
    result.title = [dict objectForKey:@"name"];
    result.desc = [dict objectForKey:@"description"];
    return result;
}

- (BOOL)parseLoginResponseData:(NSData *)data error:(NSError **)error {
    // TODO get authentication_token from dictionary
    NSLog(@"login response: %.*s", data.length, data.bytes);
    return YES;
}

- (NSArray *)parseDealsResponseData:(NSData *)data error:(NSError **)error {
    NSArray *array = [data objectFromJSONData];
    if(![array isKindOfClass:NSArray.class]){
        DDErrorAssign(@"Expecting a array in response: %.*s", data.length, data.bytes);
        return nil;
    }
    NSMutableArray *result = [NSMutableArray arrayWithCapacity:array.count];
    for (NSDictionary *dict in array) {
        NSDictionary *dictionary = [data objectFromJSONData];
        MICoupon *coupon = [self parseDealJson:dictionary];
        [result addObject:coupon];
    }
    return array;
}

- (BOOL)isLoggedIn {
    return authToken != nil;
}

- (MICoupon *)parseDealResponseData:(NSData *)data error:(NSError **)error {
    NSDictionary *dictionary = [data objectFromJSONData];
    return [self parseDealJson:dictionary];
}

- (void)loginWithDelegate:(id<MILoginDelegate>)delegate {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SERVER_URL "users/sign_in.json"]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    [request setValue:username forHTTPHeaderField:@"user[email]"];
    [request setValue:password forHTTPHeaderField:@"user[password]"];
    GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (!data) {
            [delegate loginFailedWithError:error];
            return;
        }
        NSError *parseError = nil;
        if (![self parseLoginResponseData:data error:&parseError]) {
            [delegate loginFailedWithError:parseError];    
            return;
        }
        [delegate loginFinished];
    }];
}

- (void)fetchDealsWithDelegate:(id<MIFetchDealsDelegate>)delegate {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:SERVER_URL "deals.json"]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    [request setValue:authToken forHTTPHeaderField:@"auth_token"];
    GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (!data) {
            [delegate fetchDealsFailedWithError:error];
            return;
        }
        NSError *parseError = nil;
        NSArray *deals = [self parseDealsResponseData:data error:&parseError];
        if (!deals) {
            [delegate fetchDealsFailedWithError:parseError];
            return;
        }
        [delegate fetchDealsFinishedWithDeals:deals];
    }];    
}

- (void)fetchDealWithId:(NSString *)dealId delegate:(id<MIFetchDealsDelegate>)delegate {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:SERVER_URL "deal/%@.json", dealId]]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:30];
    [request setValue:authToken forHTTPHeaderField:@"auth_token"];
    GDataHTTPFetcher *fetcher = [GDataHTTPFetcher httpFetcherWithRequest:request];
    [fetcher beginFetchWithCompletionHandler:^(NSData *data, NSError *error) {
        if (!data) {
            [delegate fetchDealsFailedWithError:error];
            return;
        }
        NSError *parseError = nil;
        NSArray *deals = [self parseDealsResponseData:data error:&parseError];
        if (!deals) {
            [delegate fetchDealsFailedWithError:parseError];
            return;
        }
        [delegate fetchDealsFinishedWithDeals:deals];
    }];    
}

@end
