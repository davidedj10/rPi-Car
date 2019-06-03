#import <Cocoa/Cocoa.h>

@interface MyWindowController : NSWindowController {
     
    IBOutlet NSTextField *ipAddress;
    IBOutlet NSLevelIndicator *upAXIS;
    IBOutlet NSLevelIndicator *downAXIS;
    IBOutlet NSLevelIndicator *leftAXIS;
    IBOutlet NSLevelIndicator *rightAXIS;
    IBOutlet NSTextField *conrateField;
    IBOutlet NSSlider *conrate;
    IBOutlet NSTextField *ratioUP;
    IBOutlet NSTextField *ratioDOWN;
    IBOutlet NSTextField *ratioLEFT;
    IBOutlet NSTextField *ratioRIGHT;
}

-(IBAction)connect:(id)sender;
-(IBAction)updateRate:(id)sender;

@end
