#import <Cocoa/Cocoa.h>
#import "MyWindowController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate> {

    MyWindowController *myWindowController;

}

@property (assign) IBOutlet NSWindow *window;



@end
