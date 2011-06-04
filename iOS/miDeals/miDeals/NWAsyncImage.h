//
//  NWAsyncImage.h
//  NWToolbox
//
//  Created by Martijn on 07-02-10.
//  Copyright 2010 n	oodlewerk.com. All rights reserved.
//


@class GDataHTTPFetcher;
@class NWAsyncImage;

extern NSString* const NWAsyncImageFinishedLoadingNotification;
extern NSString* const NWAsyncImageLoadedFromCacheNotification;
extern NSString* const NWAsyncImageUsingPlaceholderNotification;
extern NSString* const NWAsyncImageCancelledNotification;

@protocol NWAsyncImageDelegate
@optional
- (void)asyncImageDidFinishLoading:(NWAsyncImage*)image;
- (void)asyncImageDidLoadFromCache:(NWAsyncImage*)image;
- (void)asyncImageUsingPlaceholder:(NWAsyncImage*)image;
- (void)asyncImageCancelled:(NWAsyncImage*)image;
@end


@interface NWAsyncImage : NSObject
{
	NSURL*														sourceURL;
	
	GDataHTTPFetcher*									imageFetcher;
	NSObject<NWAsyncImageDelegate>*		delegate;
	BOOL															runInEventTrackingLoop;
	
	UIImage*													placeHolderImage;
	
	CGFloat														scale;
	BOOL															isFinishedLoadingImage;
	NSMutableDictionary*							_cacheDict;
}

@property (nonatomic) BOOL isFinishedLoadingImage;
@property (nonatomic) BOOL runInEventTrackingLoop;
@property (nonatomic, retain) NSURL* sourceURL;
@property (nonatomic, assign) NSObject<NWAsyncImageDelegate>* delegate;
@property (nonatomic, readonly) UIImage* image;

- (void)loadImageFromURL:(NSURL *)sourceURL;
- (void)loadImageFromURL:(NSURL *)sourceURL withPlaceHolderImage:(UIImage *)placeholder;
- (void)loadImageFromURL:(NSURL *)sourceURL scale:(CGFloat)scale withPlaceHolderImage:(UIImage *)placeholder;

+ (void)cleanupCacheOlderThan:(NSTimeInterval)seconds;

//! To be used with imageNamed:
+ (NSString*)cachePathRelativeToBundlePathForURL:(NSURL*)url;

@end



#pragma mark -
#pragma mark UIImage protocol

@interface NWAsyncImage (UIImage)
@property (nonatomic,readonly) CGSize             size;
@property (nonatomic,readonly) CGImageRef         CGImage;
@property (nonatomic,readonly) UIImageOrientation imageOrientation;
@property (nonatomic,readonly) NSInteger leftCapWidth;
@property (nonatomic,readonly) NSInteger topCapHeight; 

- (void)drawAtPoint:(CGPoint)point;
- (void)drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void)drawInRect:(CGRect)rect;
- (void)drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha;
- (void)drawAsPatternInRect:(CGRect)rect;

- (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight;
@end


#pragma mark - 
#pragma mark UIImageAdditions

@interface NWAsyncImage (UIImageAdditions)
- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode;
- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode alpha:(CGFloat)alpha;
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius;
- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode;
@end

