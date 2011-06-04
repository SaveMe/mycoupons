//
//  NSData+NWToolbox.m
//  NWToolbox
//
//  Created by Martijn on 08-12-09.
//  Copyright 2009 noodlewerk.com. All rights reserved.
//

#import "NSData+NWToolbox.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access
#import <CommonCrypto/CommonHMAC.h>

@implementation NSData_NWToolbox @end
@implementation NSData (NWToolbox)

- (NSString*)hexadecimalRepresentation
{
	NSMutableString *ms = [NSMutableString string];
	unsigned char* bytes = (unsigned char*) [self bytes];
	for (int i = 0; i < [self length]; i++)
		[ms appendFormat: @"%02x", bytes[i]];
	return ms;
}

- (NSString*)md5
{
	unsigned char result[16];
	CC_MD5( self.bytes, self.length, result ); // This is the md5 call
	return [NSString stringWithFormat:
					@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
					result[0], result[1], result[2], result[3], 
					result[4], result[5], result[6], result[7],
					result[8], result[9], result[10], result[11],
					result[12], result[13], result[14], result[15]
					];  
}

- (NSData*)hmacSHA1WithKey:(NSString*)key
{
	return [self hmacSHA1WithKeyData:[key dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSData*)hmacSHA1WithKeyData:(NSData*)keyData
{
	uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
	CCHmacContext hmacContext;
	CCHmacInit(&hmacContext, kCCHmacAlgSHA1, keyData.bytes, keyData.length);
	CCHmacUpdate(&hmacContext, self.bytes, self.length);
	CCHmacFinal(&hmacContext, digest);	
	return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

@end
