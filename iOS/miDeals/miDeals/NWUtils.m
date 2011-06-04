//
//  Utils.m
//  Martijn's Utility Library
//
//  Created by Martijn on 07-07-09.
//  Copyright 2009 noodlewerk.com. All rights reserved.
//

#import "NWUtils.h"
#import <dlfcn.h>
#import <sys/types.h>

#pragma mark -
#pragma mark SuperFastHash

// SuperFastHash function:
// From http://www.azillionmonkeys.com/qed/hash.html

#undef get16bits
#if (defined(__GNUC__) && defined(__i386__)) || defined(__WATCOMC__) \
|| defined(_MSC_VER) || defined (__BORLANDC__) || defined (__TURBOC__)
#define get16bits(d) (*((const uint16_t *) (d)))
#endif

#if !defined (get16bits)
#define get16bits(d) ((((uint32_t)(((const uint8_t *)(d))[1])) << 8)\
+(uint32_t)(((const uint8_t *)(d))[0]) )
#endif

uint32_t superFastHash (const char * data, int len, uint32_t hash) {
	uint32_t tmp;
	int rem;
	
	if (len <= 0 || data == NULL) return 0;
	
	rem = len & 3;
	len >>= 2;
	
	/* Main loop */
	for (;len > 0; len--) {
		hash  += get16bits (data);
		tmp    = (get16bits (data+2) << 11) ^ hash;
		hash   = (hash << 16) ^ tmp;
		data  += 2*sizeof (uint16_t);
		hash  += hash >> 11;
	}
	
	/* Handle end cases */
	switch (rem) {
		case 3: hash += get16bits (data);
			hash ^= hash << 16;
			hash ^= data[sizeof (uint16_t)] << 18;
			hash += hash >> 11;
			break;
		case 2: hash += get16bits (data);
			hash ^= hash << 11;
			hash += hash >> 17;
			break;
		case 1: hash += *data;
			hash ^= hash << 10;
			hash += hash >> 1;
	}
	
	/* Force "avalanching" of final 127 bits */
	hash ^= hash << 3;
	hash += hash >> 5;
	hash ^= hash << 4;
	hash += hash >> 17;
	hash ^= hash << 25;
	hash += hash >> 6;
	
	return hash;
}


#pragma mark -
#pragma mark Debugger Integrity check

typedef int (*ptrace_ptr_t)(int _request, pid_t _pid, caddr_t _addr, int _data);
#if !defined(PT_DENY_ATTACH)
#define PT_DENY_ATTACH  31
#endif  // !defined(PT_DENY_ATTACH)

void debugProtection()
{
	// If all assertions are enabled, we're in a legitimate debug build.
#if DEBUG
	return;
#endif
	
	// Lame obfuscation of the string "ptrace".
	char* ptrace_root = "ipaddr";
	char ptrace_name[] = {0x07, 0x04, 0x11, 0xfd, 0xff, 0xf3, 0x00};
	for (size_t i = 0; i < sizeof(ptrace_name); i++) {
		ptrace_name[i] += ptrace_root[i];
	}
	
	void* handle = dlopen(0, RTLD_GLOBAL | RTLD_NOW);
	ptrace_ptr_t ptrace_ptr = dlsym(handle, ptrace_name);
	ptrace_ptr(PT_DENY_ATTACH, 0, 0, 0);
	dlclose(handle);
}

#if DEBUG

#pragma mark -
#pragma mark MDSimulatorKeystrokes simulator keystroke capturer
#pragma mark -

@implementation MDSimulatorKeystrokes

- (id) init
{
	self = [super init];
	if (self != nil) {
		
		triggers = [[NSMutableArray alloc] init];
		
		UITextField* textField = [[UITextField alloc] initWithFrame: CGRectMake(0, 0, 50, 50)];
		[textField setHidden:YES];
		[textField setAutocorrectionType:UITextAutocorrectionTypeNo];
		[textField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
		[textField setDelegate: self];
		
		[[[UIApplication sharedApplication] keyWindow] addSubview: textField];
		
		[textField becomeFirstResponder];
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChange:) name:@"UITextFieldTextDidChangeNotification" object:textField];
		
		keyboardImpl = [NSClassFromString(@"UIKeyboardImpl") performSelector:@selector(sharedInstance)];
		
		[[keyboardImpl superview] setHidden:YES];
		[keyboardImpl setHidden:YES];
		
	}
	return self;
}

- (void) textFieldTextDidChange:(NSNotification*)sentNotification
{
	UITextField* textField = (UITextField*) [sentNotification object];
	
	// Ignore the notification if the textfield is empty
	if ([[textField text] isEqualToString:@""] == NO)
	{
		for (NSDictionary* trig in triggers)
		{
			// See if the keypress matches 
			if ([[[textField text] lowercaseString] isEqualToString:[trig objectForKey:@"key"]])
			{
				// NSLog(@"Sending notification \"%@\" for keypress \"%@\" with userInfo\n%@", [trig objectForKey:@"notificationName"], [trig objectForKey:@"key"], [trig objectForKey:@"userInfo"]);
				[[NSNotificationCenter defaultCenter] postNotificationName:[trig objectForKey:@"notificationName"] object:self userInfo:[trig objectForKey:@"userInfo"]];
			}
		}
		
		// clear the textfield:
		[textField setText:@""];
	}
} 

// Hook a new notification to a keypress:
- (void) onKey:(NSString*)key postNotificationName:(NSString *)notificationName withUserInfo:(NSDictionary *)userInfo
{
	NSDictionary* newTrigger = [NSDictionary dictionaryWithObjectsAndKeys: key, @"key", notificationName, @"notificationName", userInfo, @"userInfo", nil];
	// add the new trigger to our array:
	[triggers addObject: newTrigger];
}

- (void) dealloc
{
	[super dealloc];
}

@end

#pragma mark -
#pragma mark DebugSupport

@implementation DebugSupport

static DebugSupport *debugSupportInstance;

+ (void)redirectConsoleLogToDocumentFolder
{
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *logPath = [documentsDirectory stringByAppendingPathComponent:@"console.log"];
  freopen([logPath cStringUsingEncoding:NSASCIIStringEncoding],"a+",stderr);
}

- (void)promptForDebugger
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	waiting = YES;
	NSString *prompt = [NSString stringWithFormat:@"Attach Debuger, PID %d", getpid()];
	UIAlertView *view = [[UIAlertView alloc] initWithTitle:@"Debug" message:prompt delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
	[view show];
	[view release];
	[pool release];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
	waiting = NO;
}

- (BOOL)waiting
{
	return waiting;
}

+ (void)waitForDebugger
{
	if (debugSupportInstance == nil)
	{
		debugSupportInstance = [[DebugSupport alloc] init];
	}
	
	[debugSupportInstance promptForDebugger];
	
	[NSThread detachNewThreadSelector:@selector(promptForDebugger) toTarget:debugSupportInstance withObject:nil];
	
	while([debugSupportInstance waiting])
	{
		;
	}
	
	[debugSupportInstance autorelease];
}

@end

#endif