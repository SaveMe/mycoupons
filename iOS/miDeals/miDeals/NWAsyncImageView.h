//
//  NWAsyncImageView.h
//  NWToolbox
//
//  Created by Martijn on 22-03-10.
//  Copyright 2010 noodlewerk.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NWAsyncImage.h"

@class NWAsyncImage;

@interface NWAsyncImageView : UIImageView <NWAsyncImageDelegate>
{
	NWAsyncImage* asyncImage;
    BOOL crossFade;
}

@property (nonatomic, retain) NWAsyncImage *asyncImage;
@property (nonatomic) BOOL crossFade;

- (void)loadImageFromURL:(NSURL *)sourceURL;
- (void)loadImageFromURL:(NSURL *)sourceURL withPlaceHolderImage:(UIImage *)placeholder;
- (void)loadImageFromURL:(NSURL *)sourceURL scale:(CGFloat)scale withPlaceHolderImage:(UIImage *)placeholder;

@end

