//
//  NSString+NWToolbox.m
//  NWToolbox
//
//  Created by Martijn on 08-12-09.
//  Copyright 2009 noodlewerk.com. All rights reserved.
//

#import "NSString+NWToolbox.h"
#import "NSData+NWToolbox.h"
#import <CommonCrypto/CommonDigest.h> // Need to import for CC_MD5 access

@implementation NSString_NWToolbox @end
@implementation NSString (NWToolbox)

+ (NSString*)UUID
{
	CFUUIDRef theUUID = CFUUIDCreate(NULL);
	CFStringRef string = CFUUIDCreateString(NULL, theUUID);
	NSMakeCollectable(theUUID);
	NSString* result = (NSString *)string;
	CFRelease(theUUID);
	return [result autorelease];
}

+ (NSString*)stringLatin1WithString:(NSString*)aString
{
	// Check for Latin-1 charset:
	if ([aString canBeConvertedToEncoding:NSISOLatin1StringEncoding] == NO)
	{
		// Convert to Latin-1:
		NSData* stringData = [aString dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:YES];
		NSString* convertedString = [[NSString alloc] initWithData:stringData encoding:NSISOLatin1StringEncoding];
		return [convertedString autorelease];
	}
	// If already compatible:
	return aString;
}


+ (NSString*)stringISO8601FromDate:(NSDate *)date
{
	static NSDateFormatter* sISO8601 = nil;
	
	if (!sISO8601) {
		sISO8601 = [[NSDateFormatter alloc] init];
		
		NSTimeZone *timeZone = [NSTimeZone localTimeZone];
		int offset = [timeZone secondsFromGMT];
		
		NSMutableString *strFormat = [NSMutableString stringWithString:@"yyyy-MM-dd'T'HH:mm:ss"];
		offset /= 60; //bring down to minutes
		if (offset == 0)
			[strFormat appendString:@"Z"];
		else
			[strFormat appendFormat:@"%+02d%02d", offset / 60, offset % 60];
		
		[sISO8601 setTimeStyle:NSDateFormatterFullStyle];
		[sISO8601 setDateFormat:strFormat];
	}
	return[sISO8601 stringFromDate:date];
} 

- (NSString *)md5
{
	const char *cStr = [self UTF8String];
	unsigned char result[16];
	CC_MD5( cStr, strlen(cStr), result ); // This is the md5 call
	return [NSString stringWithFormat:
					@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
					result[0], result[1], result[2], result[3], 
					result[4], result[5], result[6], result[7],
					result[8], result[9], result[10], result[11],
					result[12], result[13], result[14], result[15]
					];  
}

- (NSString*)sha1
{
    const char *s = [self cStringUsingEncoding:NSASCIIStringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
		
    // This is the destination
    uint8_t digest[CC_SHA1_DIGEST_LENGTH] = {0};
    // This one function does an unkeyed SHA1 hash of your hash data
    CC_SHA1(keyData.bytes, keyData.length, digest);
		
    // Now convert to NSData structure to make it usable again
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
		return [out hexadecimalRepresentation];
}

- (NSString*)stringWithPercentEscape
{            
	return [(NSString *) CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)[[self mutableCopy] autorelease], NULL, CFSTR("￼=,!$&'()*+;@?\n\"<>#\t :/"),kCFStringEncodingUTF8) autorelease];
}

@end
