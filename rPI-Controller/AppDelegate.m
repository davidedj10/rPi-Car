#import "AppDelegate.h"
#import "MyWindowController.h"


@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[NSNotificationCenter defaultCenter] addObserver:self
											 selector:@selector(appWillTerminate:)
												 name:NSApplicationWillTerminateNotification
											   object:nil];
    
    if (myWindowController == NULL)
		myWindowController = [[MyWindowController alloc] initWithWindowNibName:@"Window"];
	
	[myWindowController showWindow:self];
    

}

- (void)appWillTerminate:(NSNotification *)notification {
    

}


@end
