//
//  Utils.h
//  Martijn's Utility Library
//
//  Created by Martijn on 07-07-09.
//  Copyright 2009 noodlewerk.com. All rights reserved.
//

#import <sys/types.h>
#include <assert.h>
#include <stdbool.h>
#include <unistd.h>
#include <sys/sysctl.h>

#pragma mark -
#pragma mark Math macros


#ifndef PI
#define PI       3.14159265358979323846
#endif

#ifndef TWO_PI
#define TWO_PI   6.28318530717958647693
#endif

#define CLIP(x, lo, hi) ((x) > (hi) ? (hi) : ((x) < (lo) ? (lo) : (x)))

#define MAPL(x, a, b) x*(b - a)+a
#define UNMAPL(x, a, b) (x-a)/(b - a)

#define MAPX(x, a, b) pow((b/a),x) * a
#define UNMAPX(x, a, b) log(x/a)/log(b/a)

#define MAP60DB(x, sr) exp(log(0.1)/(x*sr))
#define UNMAP60DB(x, sr) log(0.1)/(log(x)*sr)

// works between 0 and 1
#define MAP_QUADRATIC(x) (x > 0.5) ? -2*(x-1)*(x-1)+1 : 2*x*x
#define UNMAP_QUADRATIC(x) (x > 0.5) ? 1 - sqrt((1-x)/2) : sqrt(x/2)

#define MAP_TRIGO(x) (cos(x * M_PI) - 1.0f) / -2.0f
#define UNMAP_TRIGO(x) acos((-2*x) + 1) / M_PI


#pragma mark -
#pragma mark Math stuff

inline bool randBool()
{
	return (rand() & 1);
}

inline int randi(int min, int max)
{
	return (int)((rand() / (float)RAND_MAX) * (max - min) + min);
}

inline float randfr(float min, float max)
{
	return ((rand() / (float)RAND_MAX) * (max - min) + min);
}

inline float randf()
{
	return rand() / (float)RAND_MAX;
}

inline float randfs()
{
	return 2.0f * (float)rand() / (RAND_MAX) - 1.0f;
}

inline int nextPow2(int i)
{
	int ret = 1;
	while (ret < i) ret <<= 1;
	return ret;
}


inline UInt32 wrap(UInt32 in, UInt32 lo, UInt32 hi) 
{
	UInt32 range;
	// avoid the divide if possible
	if (in >= hi) {
		range = hi - lo;
		in -= range;
		if (in < hi) return in;
	} else if (in < lo) {
		range = hi - lo;
		in += range;
		if (in >= lo) return in;
	} else return in;
	
	if (hi == lo) return lo;
	return in - range * floor((in - lo)/range); 
}

inline SInt32 wrapS(SInt32 in, SInt32 lo, SInt32 hi) 
{
	UInt32 range;
	// avoid the divide if possible
	if (in >= hi) {
		range = hi - lo;
		in -= range;
		if (in < hi) return in;
	} else if (in < lo) {
		range = hi - lo;
		in += range;
		if (in >= lo) return in;
	} else return in;
	
	if (hi == lo) return lo;
	return in - range * floor((in - lo)/range); 
}





#pragma mark -
#pragma mark SuperFastHash

uint32_t superFastHash (const char * data, int len, uint32_t hash);
/*uint32_t inline superFastHash (const char * data, int len) {
	return superFastHash (data, len, len);
}*/

#ifdef DEBUG
static bool AmIBeingDebugged(void)
// Returns true if the current process is being debugged (either
// running under the debugger or has a debugger attached post facto).
{
    int                 junk;
    int                 mib[4];
    struct kinfo_proc   info;
    size_t              size;
	
    // Initialize the flags so that, if sysctl fails for some bizarre
    // reason, we get a predictable result.
	
    info.kp_proc.p_flag = 0;
	
    // Initialize mib, which tells sysctl the info we want, in this case
    // we're looking for information about a specific process ID.
	
    mib[0] = CTL_KERN;
    mib[1] = KERN_PROC;
    mib[2] = KERN_PROC_PID;
    mib[3] = getpid();
	
    // Call sysctl.
	
    size = sizeof(info);
    junk = sysctl(mib, sizeof(mib) / sizeof(*mib), &info, &size, NULL, 0);
    assert(junk == 0);
	
    // We're being debugged if the P_TRACED flag is set.
	
    return ( (info.kp_proc.p_flag & P_TRACED) != 0 );
}

bool AmIBeingDebugged(void);
#endif




// Logging Macros From:
// http://iphoneincubator.com/blog/debugging/the-evolution-of-a-replacement-for-nslog
// DLog is almost a drop-in replacement for NSLog
// DLog();
// DLog(@"here");
// DLog(@"value: %d", x);
// Unfortunately this doesn't work DLog(aStringVariable); you have to do this instead DLog(@"%@", aStringVariable);
#ifdef DEBUG
#	define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#	define DLog(...)
#endif


#pragma mark -
#pragma mark Reverse Engineering protections
#pragma mark -

void debugProtection();



#if DEBUG

#pragma mark -
#pragma mark MDSimulatorKeystrokes simulator keystroke capturer

@interface MDSimulatorKeystrokes : NSObject <UITextFieldDelegate>
{
	id keyboardImpl;
	NSMutableArray* triggers;
}
- (void) textFieldTextDidChange:(NSNotification*)sentNotification;
- (void) onKey:(NSString*)key postNotificationName:(NSString *)notificationName withUserInfo:(NSDictionary *)userInfo;

@end

#pragma mark -
#pragma mark DebugSupport

@interface DebugSupport : NSObject<UIAlertViewDelegate>
{
	BOOL waiting;
}

+ (void)redirectConsoleLogToDocumentFolder;
+ (void)waitForDebugger;	// Helper to attach debugger

@end

#endif