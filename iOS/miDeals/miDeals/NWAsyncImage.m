//
//  NWAsyncImage.m
//  NWToolbox
//
//  Created by Martijn on 07-02-10.
//  Copyright 2010 noodlewerk.com. All rights reserved.
//

#import "NWAsyncImage.h"
#import "GDataHTTPFetcher.h"
#import "GDataHTTPFetcherLogging.h"
#import "UIImageAdditions.h"
#import "NWUtils.h"
#import "NSString+NWToolbox.h"


#ifndef __IPHONE_4_0
#define __IPHONE_4_0 40000
#endif

#define kNWAsyncImageTimeoutInterval		20

const double NWAsyncImageMaxCacheAge = 1209600.0;														// Maximum cache age in seconds
NSString* const NWAsyncImageFinishedLoadingNotification = @"NWAsyncImageFinishedLoadingNotification";
NSString* const NWAsyncImageLoadedFromCacheNotification = @"NWAsyncImageLoadedFromCacheNotification";
NSString* const NWAsyncImageUsingPlaceholderNotification = @"NWAsyncImageUsingPlaceholderNotification";
NSString* const NWAsyncImageCancelledNotification = @"NWAsyncImageCancelledNotification";

NSString* const NWAsyncImageCacheFolderName = @"NWAsyncImageCacheFolderName";
NSString* const NWFileName = @"fileName";
NSString* const NWRelativeDictionaryFilePath = @"../Library/Caches/NWAsyncImageDictionary.plist";

static NSString* NWAsyncImageCachePath = nil;
static NSMutableDictionary* NWAsyncImagePendingRequests = nil;
static NSMutableDictionary* asyncImageDictionary = nil;

@interface NWAsyncImage (Private)
+ (NSString*)sharedCachesFolder;
- (BOOL)tryLoadCachedImageFromDisk;
- (void)saveImageToCacheWithData:(NSData*)data;
- (void)resetFetcher;
- (NSString*)cachePathRelativeToBundlePath;
- (UIImage*)scaleImaged:(UIImage*)anImage;
- (NSMutableDictionary*)cacheDict;
+ (NSMutableDictionary*)asyncImageDictionary;
@end


#pragma mark -
#pragma mark Public Methods


@implementation NWAsyncImage

@synthesize isFinishedLoadingImage;
@synthesize delegate;
@synthesize sourceURL;
@synthesize runInEventTrackingLoop;

+ (NSString*)dictionaryFilePath
{
	return [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:NWRelativeDictionaryFilePath];
}

+ (NSString*)cachePathRelativeToBundlePathForURL:(NSURL*)sourceURL
{
	if (sourceURL == nil)
		return nil;
	
	NSString* fileName = [[sourceURL absoluteString] md5];
	if (fileName == nil) return nil;
	NSString* relativeCachePath = [NSString stringWithFormat:@"../Library/Caches/NWAsyncImageCacheFolderName/%@", fileName];
	
	NSMutableDictionary* dict = [NSMutableDictionary dictionaryWithCapacity:2];
	[dict setObject:relativeCachePath forKey:NWFileName];
	[[NWAsyncImage asyncImageDictionary] setObject:dict forKey:sourceURL];
	
	return relativeCachePath;
	
}

// Save the cache Dictionary when resign active of termination
+ (void)saveDictionary:(NSNotification*)noti
{	
	NSMutableData *data = [[NSMutableData alloc] init];
	NSKeyedArchiver *archiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
	[archiver encodeObject:[NWAsyncImage asyncImageDictionary] forKey:NWRelativeDictionaryFilePath];
	[archiver finishEncoding];
	
	[data writeToFile:[self dictionaryFilePath] atomically:YES];
	[data release];
	[archiver release];
}
#pragma mark -
#pragma mark Object Lifecycle

- (void)setSourceURL:(NSURL *)newSourceURL
{
	if (newSourceURL == sourceURL) return;
	[newSourceURL retain];
	[sourceURL release];
	sourceURL = newSourceURL;
	[_cacheDict release];
	_cacheDict = nil;
}

- (UIImage*)image
{
	// Rely on UIImage imageNamed: for memory management and caching;
	UIImage* cachedImage = [self scaleImaged:[UIImage imageNamed:[self cachePathRelativeToBundlePath]]];
	if (cachedImage) return cachedImage;
	
	// If no valid image, return the placeholder:
	return placeHolderImage;
}

- (void)loadImageFromURL:(NSURL *)theSourceURL
{
	[self loadImageFromURL:theSourceURL withPlaceHolderImage:nil];
}

- (void)loadImageFromURL:(NSURL *)theSourceURL withPlaceHolderImage:(UIImage *)placeholder
{
	[self loadImageFromURL:theSourceURL scale:1.0f withPlaceHolderImage:placeholder];
}

- (void)loadImageFromURL:(NSURL *)theSourceURL scale:(CGFloat)_scale withPlaceHolderImage:(UIImage *)placeholder
{
	NSAssert([NSThread isMainThread], @"loadImageFromURL:scale:withPlaceHolderImage: should only be called from mainThread!");
	
	@synchronized([self class])
	{
		if (NWAsyncImagePendingRequests == nil)
			NWAsyncImagePendingRequests = [[NSMutableDictionary alloc] init];
	}
	
	//if (imageFetcher)
	if ([theSourceURL isEqual:sourceURL])
		if (imageFetcher) return; // already fetching this image, no need to start over again.

	scale = _scale;
	
	[self resetFetcher];
	
	// Catch URL that were created with an empty string:
	if ([[theSourceURL absoluteString] isEqualToString:@""])
		theSourceURL = nil;
	
	self.sourceURL = theSourceURL;
	
	// Try to locate image in the cache folder:
	BOOL didLoadCache = [self tryLoadCachedImageFromDisk];
	
	if (didLoadCache == NO)
	{
		if (sourceURL != nil)
		{
			// If already fetching:
			NWAsyncImage* pendingAsyncImage;
			@synchronized(NWAsyncImagePendingRequests)
			{	pendingAsyncImage = [NWAsyncImagePendingRequests objectForKey:sourceURL]; }
			if (pendingAsyncImage)
			{
				// Listen for notifications of the other NWAsyncImage to finish:
				[[NSNotificationCenter defaultCenter] addObserver:self
																								 selector:@selector(pendingFetchDidFinish:)
																										 name:nil
																									 object:pendingAsyncImage];
			}
			else
			{
				// Start fetching image:
				imageFetcher = [[GDataHTTPFetcher alloc] initWithRequest: [NSMutableURLRequest requestWithURL: sourceURL
																																													cachePolicy: NSURLRequestReloadIgnoringCacheData
																																											timeoutInterval: kNWAsyncImageTimeoutInterval]];
				// Add to pending requests:
				@synchronized(NWAsyncImagePendingRequests)
				{
					[NWAsyncImagePendingRequests setObject:self
																					forKey:sourceURL];
				}
								
				[imageFetcher setCookieStorageMethod:kGDataHTTPFetcherCookieStorageMethodSystemDefault];
				[imageFetcher setRetryFactor:1.0];
				if(runInEventTrackingLoop)
				{
					NSArray *modes = [NSArray arrayWithObjects:NSDefaultRunLoopMode,UITrackingRunLoopMode, nil];
					[imageFetcher setRunLoopModes:modes];
				}
				
				[imageFetcher setIsRetryEnabled: YES];
				[imageFetcher setRetrySelector:@selector(fetcher:willRetry:forError:)];
				
				[imageFetcher beginFetchWithDelegate:self
													 didFinishSelector:@selector(fetcher:finishedWithData:)
									 didFailWithStatusSelector:@selector(fetcher:failedWithStatus:data:)
										didFailWithErrorSelector:@selector(fetcher:failedWithError:)];
			}
		}

		// Set the placeholder, but don't send notification yet:
		[placeholder retain];
		[placeHolderImage release];
		placeHolderImage = placeholder;
		
		// Call the delegate:
		if ([delegate respondsToSelector:@selector(asyncImageUsingPlaceholder:)])
			[delegate asyncImageUsingPlaceholder:self];
		// Send notification:
		[[NSNotificationCenter defaultCenter] postNotificationName:NWAsyncImageUsingPlaceholderNotification object:self];
	}
}


- (id) init
{
	self = [super init];
	if (self != nil) {
		[NWAsyncImage sharedCachesFolder]; // triggers creating of the sharedCachesFolder if not existing...
	}
	return self;
}


- (void)dealloc
{
	// Stop listening:
	[[NSNotificationCenter defaultCenter] removeObserver:self];
	[self resetFetcher];
	self.sourceURL = nil;
	
	[placeHolderImage release]; placeHolderImage = nil;
	
	[super dealloc];
}

- (void)pendingFetchDidFinish:(NSNotification*)sentNotification
{
	if ([[sentNotification name] isEqualToString:NWAsyncImageUsingPlaceholderNotification])
		return; 	// The parent did load a placeholder, do nothing (we already show the placeholder...)
	
	// Stop listening:
	NSNotificationCenter* nc = [NSNotificationCenter defaultCenter];
	[nc removeObserver:self];
	
	// Load the image (from cache, or if the "parent" has been cancelled, start loading again):
	[self loadImageFromURL:sourceURL scale:scale withPlaceHolderImage:placeHolderImage];
}

#pragma mark -
#pragma mark GDataHTTPFetcher delegate methods

-(BOOL)fetcher:(GDataHTTPFetcher *)fetcher willRetry:(BOOL)suggestedWillRetry forError:(NSError *)error
{
	return suggestedWillRetry;
}


- (void)fetcher:(GDataHTTPFetcher *)fetcher finishedWithData:(NSData *)data
{
	if (imageFetcher != nil)
	{		
		// Save file to cache folder:
		[self saveImageToCacheWithData:data];
	
		// Touch the fileModificationDate of the file, to mark that we used it, so it won't get deleted:
		[[self cacheDict] setObject:[NSDate date] forKey:NSFileModificationDate];
		
		// Remove from the pending requests list:
		@synchronized(NWAsyncImagePendingRequests)
		{	[NWAsyncImagePendingRequests removeObjectForKey:sourceURL]; }
		
		// Init the image:
		UIImage* theImage = [UIImage imageNamed:[self cachePathRelativeToBundlePath]];
		UIImage* cachedImage = [self scaleImaged:theImage];

		[self resetFetcher];

		if (cachedImage)
		{
			isFinishedLoadingImage = YES;
			// Call the delegate:
			if ([delegate respondsToSelector:@selector(asyncImageDidFinishLoading:)])
				[delegate asyncImageDidFinishLoading:self];
			// Post notification:
			[[NSNotificationCenter defaultCenter] postNotificationName:NWAsyncImageFinishedLoadingNotification
																														object:self];
		}
		else
		{
			// The loaded image is invalid:
			// TODO: Call delegate & send notification?
		}
	}
}


- (void)fetcher:(GDataHTTPFetcher *)fetcher failedWithStatus:(NSInteger)status data:(NSData *)data
{
	DLog(@"NWAsyncImageView error: Status %i, %@", status, [fetcher request]);
	[self resetFetcher];
}


- (void)fetcher:(GDataHTTPFetcher *)fetcher failedWithError:(NSError *)error
{
    [self resetFetcher];
    if(error.code != -1009) // No internet
    	DLog(@"NWAsyncImageView error: %@", error);
}

+ (void)cleanupCacheOlderThan:(NSTimeInterval)seconds
{
	/* Clean up really old files */
	NSError* error = nil;
	NSTimeInterval time;
	NSFileManager* fileManager = [NSFileManager defaultManager];
	NSMutableDictionary* mainDict = [[self asyncImageDictionary] copy];
	for(NSString* key in mainDict)
	{
		NSDictionary* dict = [mainDict objectForKey:key];
		NSDate* modificationDate = [dict objectForKey:NSFileModificationDate];
		
		if (modificationDate != nil)
		{
			// If the modificationDate is older than NWAsyncImageMaxCacheAge, remove the file
			time = fabs([modificationDate timeIntervalSinceNow]);
			if (time > seconds)
			{
				error = nil;
				[fileManager removeItemAtPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[dict objectForKey:NWFileName]] error:&error];
				[[self asyncImageDictionary] removeObjectForKey:key];
			}
		}
	}
	[mainDict release];
}


@end


@implementation NWAsyncImage (UIImage)

#pragma mark -
#pragma mark Forward to UIImage

- (CGFloat)scale
{
	if ([[self image] respondsToSelector:@selector(scale)])
		return [self scale];
	else return 1;
}

- (CGSize)size
{
	return [[self image] size];
}

- (CGImageRef)CGImage
{
	return [[self image] CGImage];
}

- (UIImageOrientation)imageOrientation
{
	return [[self image] imageOrientation];
}

- (NSInteger)leftCapWidth
{
	return [[self image] leftCapWidth];
}

- (NSInteger)topCapHeight
{
	return [[self image] topCapHeight];
}

- (void)drawAtPoint:(CGPoint)point;
{
	[[self image] drawAtPoint:point];
}

- (void)drawAtPoint:(CGPoint)point blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
	[[self image] drawAtPoint:point blendMode:blendMode alpha:alpha];
}

- (void)drawInRect:(CGRect)rect
{
	[[self image] drawInRect:rect];
}

- (void)drawInRect:(CGRect)rect blendMode:(CGBlendMode)blendMode alpha:(CGFloat)alpha
{
	[[self image] drawInRect:rect blendMode:blendMode alpha:alpha];
}

- (void)drawAsPatternInRect:(CGRect)rect
{
	[[self image] drawAsPatternInRect:rect];
}

- (UIImage *)stretchableImageWithLeftCapWidth:(NSInteger)leftCapWidth topCapHeight:(NSInteger)topCapHeight
{
	return [[self image] stretchableImageWithLeftCapWidth:leftCapWidth topCapHeight:topCapHeight];
}

@end


#pragma mark -
#pragma mark UIImageAdditions

@implementation NWAsyncImage (UIImageAdditions)
- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode
{
	[[self image] drawInRect:rect contentMode:contentMode];
}

- (void)drawInRect:(CGRect)rect contentMode:(UIViewContentMode)contentMode alpha:(CGFloat)alpha
{
	[[self image] drawInRect:rect contentMode:contentMode alpha:alpha];
}

- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius
{
	[[self image] drawInRect:rect radius:radius];
}

- (void)drawInRect:(CGRect)rect radius:(CGFloat)radius contentMode:(UIViewContentMode)contentMode
{
	[[self image] drawInRect:rect radius:radius contentMode:contentMode];
}

@end


#pragma mark -
#pragma mark Private

@implementation NWAsyncImage (Private)

// The cache Dictionary
+ (NSMutableDictionary*)asyncImageDictionary
{
	if(!asyncImageDictionary)
	{
		NSDictionary* dict = nil;
		NSData *data = [[NSMutableData alloc]initWithContentsOfFile:[self dictionaryFilePath]];
		if (data)
		{
			NSKeyedUnarchiver *unarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
			dict = [unarchiver decodeObjectForKey:NWRelativeDictionaryFilePath];
			[unarchiver finishDecoding];
			[unarchiver release];
			[data release];
		}
		
		if(dict)
			asyncImageDictionary = [[NSMutableDictionary dictionaryWithDictionary:dict] retain];
		else 
			asyncImageDictionary = [[NSMutableDictionary alloc] init];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDictionary:) name:UIApplicationWillResignActiveNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveDictionary:) name:UIApplicationWillTerminateNotification object:nil];
	}
	return asyncImageDictionary;
}

- (UIImage*)scaleImaged:(UIImage*)anImage
{
	#if __NW_CURRENT_SDK_VERSION >= __IPHONE_4_0
	if (!anImage) return nil;
	if (scale <= 0.0f) return anImage;
	
	static int deviceSupportsScale = 0;
	if (deviceSupportsScale == 0)
	{
		if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0f) deviceSupportsScale = 1;
		else deviceSupportsScale = -1;
	}
	
	
	
	// If UIImage scale property is not supported, return the original image:
	if (deviceSupportsScale == -1) return anImage;
	
	// Else, return a scaled image:
	return [UIImage imageWithCGImage:[anImage CGImage] scale:scale orientation:[anImage imageOrientation]];
	#else
	return anImage;
	#endif
}

#pragma mark -
#pragma mark Cache methods

+ (NSString*)sharedCachesFolder
{
	if (NWAsyncImageCachePath)
		return NWAsyncImageCachePath;
	
	if (NWAsyncImageCachePath == nil)
	{
		NSFileManager* fileManager = [NSFileManager defaultManager];
		
		/* create path to cache directory inside the application's Documents directory */
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
		NWAsyncImageCachePath = [[[paths objectAtIndex:0] stringByAppendingPathComponent:NWAsyncImageCacheFolderName] retain];
		
		/* check for existence of cache directory */
		if (![fileManager fileExistsAtPath:NWAsyncImageCachePath])
		{
			NSError* error = nil;
			/* create a new cache directory */
			if (![fileManager createDirectoryAtPath:NWAsyncImageCachePath 
									withIntermediateDirectories:NO
																	 attributes:nil 
																				error:&error])
			{
				NSLog(@"NWAsyncImageView: Error creating cache.");
			}
		}
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cleanupCache:) name:UIApplicationWillResignActiveNotification object:nil];
	}
	
	return NWAsyncImageCachePath;
}

+ (void)cleanupCache:(NSNotification*)noti
{
	[NWAsyncImage cleanupCacheOlderThan:NWAsyncImageMaxCacheAge];
}

- (NSString*)cachePathRelativeToBundlePath
{
	NSString* relativeCachePath = [[self cacheDict] objectForKey:NWFileName];
	if (relativeCachePath)
		return relativeCachePath;
	return [NWAsyncImage cachePathRelativeToBundlePathForURL:sourceURL]; // retained by cacheDict
}

- (NSMutableDictionary*)cacheDict
{
	if(!_cacheDict)
		_cacheDict = [[[NWAsyncImage asyncImageDictionary] objectForKey:sourceURL] retain];
	return _cacheDict;
}

- (void)sendNotificationDidLoadCachedImage
{	
	// Call the delegate method:
	isFinishedLoadingImage = YES;
	if ([delegate respondsToSelector:@selector(asyncImageDidLoadFromCache:)])
		[delegate asyncImageDidLoadFromCache:self];
	// Post notification:
	[[NSNotificationCenter defaultCenter] postNotificationName:NWAsyncImageLoadedFromCacheNotification object:self];
}

- (BOOL)tryLoadCachedImageFromDisk
{
	UIImage* theImage = [UIImage imageNamed:[self cachePathRelativeToBundlePath]];
	
	// Does a file exist at the path?
	if(!theImage)
	{
	//	NSLog(@"Not cached Image:%@", self.sourceURL);
		return NO;
	}
	
	// Set image from cache:
	UIImage* cachedImage = [self scaleImaged:theImage];
	if (cachedImage)
	{
		[self sendNotificationDidLoadCachedImage];
		
		// Touch the fileModificationDate of the file, to mark that we used it, so it won't get deleted:
		[[self cacheDict] setObject:[NSDate date] forKey:NSFileModificationDate];
		
		// Report that the image is being loaded from cache:
		return YES;
	}
	
	return NO;
}

- (void)saveImageToCacheWithData:(NSData*)data
{	
	NSString* filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[self cachePathRelativeToBundlePath]];
	NSFileManager* fileManager = [NSFileManager defaultManager];
	
	// Does a file exist at the path?
	if ([fileManager fileExistsAtPath:filePath] == YES)
	{
		NSError* error = nil;
		[fileManager removeItemAtPath:filePath error:&error];
		if (error)
		{
			DLog(@"Tried to remove old cache file but could not: %@\n%@", filePath, error);
			return;
		}
	}
	
	// Save the file:
	BOOL success = [fileManager createFileAtPath:filePath
																			contents:data
																		attributes:nil];
	if (!success)
	{
		DLog(@"Saving failed...");
	}
}

#pragma mark -
#pragma mark Fetcher methods

- (void)resetFetcher
{
	if (imageFetcher)
	{
		[imageFetcher setDelegate:nil];
		[imageFetcher stopFetching];
		[imageFetcher release];
		imageFetcher = nil;
		
		// Remove from the pending requests list:
		@synchronized(NWAsyncImagePendingRequests)
		{ [NWAsyncImagePendingRequests removeObjectForKey:sourceURL]; }
		
// TODO: Waarom wordt hier canceled aangeroepen? De fetcher wordt gereset, ook bij succes
		if ([delegate respondsToSelector:@selector(asyncImageCancelled:)])
			[delegate asyncImageCancelled:self];
		
		// Post notification:
		[[NSNotificationCenter defaultCenter] postNotificationName:NWAsyncImageCancelledNotification
																											object:self];
	}
}

@end

