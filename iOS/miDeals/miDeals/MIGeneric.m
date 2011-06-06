//
//  MIGeneric.m
//  miDeals
//
//  Created by User on 6/5/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MIGeneric.h"

int nrOfTokensHack = 10;

static int PlaceHolderImageNameNr = 1;
static NSMutableDictionary *PlaceHolderImageDict = nil;

NSString *PlaceHolderImageName(NSString *url) {
	if (PlaceHolderImageDict == nil) PlaceHolderImageDict = [[NSMutableDictionary dictionaryWithCapacity:16] retain];
	NSString *result = [PlaceHolderImageDict objectForKey:url];
	NSLog(@"PlaceHolderImageName url=%@", url);
	if (result == nil) {
		result = [NSString stringWithFormat:@"DealMe-Placeholder-%d", PlaceHolderImageNameNr];
		[PlaceHolderImageDict setValue:result forKey:url];
		PlaceHolderImageNameNr++; if (PlaceHolderImageNameNr > 4) PlaceHolderImageNameNr = 1;
	}
	return result;
}
