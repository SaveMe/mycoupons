//
//  NSData+NWToolbox.h
//  NWToolbox
//
//  Created by Martijn on 08-12-09.
//  Copyright 2009 noodlewerk.com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData_NWToolbox @end
@interface NSData (NWToolbox)

- (NSString*)hexadecimalRepresentation;
- (NSString*)md5;
- (NSData*)hmacSHA1WithKey:(NSString*)key;
- (NSData*)hmacSHA1WithKeyData:(NSData*)keyData;

@end
