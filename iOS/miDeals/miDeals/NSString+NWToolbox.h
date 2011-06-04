//
//  NSString+NWToolbox.h
//  NWToolbox
//
//  Created by Martijn on 08-12-09.
//  Copyright 2009 noodlewerk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString_NWToolbox @end
@interface NSString (NWToolbox)
+ (NSString*)UUID;
+ (NSString*)stringLatin1WithString:(NSString*)aString;
+ (NSString*)stringISO8601FromDate:(NSDate *)date;
- (NSString *)md5;
- (NSString*)sha1;
- (NSString*)stringWithPercentEscape;
@end
