#import "MyWindowController.h"
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <netdb.h>
#include <netdb.h>
#include <string.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <arpa/inet.h>

float rateCONf = 0.5;
int sockfd, portno = 51718;

// REFERENCES VARIABLES

int forward = 2;
int left = 2;
int right = 2;
int backward = 2;

int serialized_buff(int x, int y, int z, int k){
    char str1[20];
    char str2[20];
    char str3[20];
    char str4[20];
    
    sprintf(str1,"%d",x);
    sprintf(str2,"%d",y);
    sprintf(str3, "%d", z);
    sprintf(str4, "%d", k);
    
    strcat(str1, str2);
    strcat(str1, str3);
    strcat(str1, str4);
    
    return atoi(str1);
}

void sendData( int sockfd, int x ) {
    
    long n;
    
    char buffer[32];
    sprintf( buffer, "%d\n", x );
    if ( (n = write( sockfd, buffer, strlen(buffer) ) ) < 0 )
        
        NSLog(@"ERROR writing to socket");
    
    buffer[n] = '\0';
}

int getData( int sockfd ) {
    char buffer[32];
    long n;
    
    if ( (n = read(sockfd,buffer,31) ) < 0 )
        NSLog(@ "ERROR reading from socket");
    buffer[n] = '\0';
    return atoi( buffer );
}


@implementation MyWindowController



- (id)initWithPath:(NSString *)newPath
{

    return [super initWithWindowNibName:@"Window"];
}

- (void)dealloc
{
	[super dealloc];
}


-(IBAction)updateRate:(id)sender{
    
    
    [conrateField setStringValue:[conrate stringValue]];
    rateCONf = [conrate floatValue];
    
}

- (void)keyUp:(NSEvent *)theEvent {
    
    NSString *keyPressed = [theEvent charactersIgnoringModifiers];
    unichar keyChar = [keyPressed characterAtIndex:0];
    
    if(keyChar == NSUpArrowFunctionKey) {
        
        NSLog(@"Pressed UP");
        
        forward = 2;
        
        [upAXIS setIntegerValue:0];
        [ratioUP setStringValue:@"0%"];
        
    }
    
    if(keyChar == NSDownArrowFunctionKey){
        
        NSLog(@"Pressed DOWN");
        
        backward = 2;
        
        [downAXIS setIntegerValue:0];
        [ratioDOWN setStringValue:@"0%"];

    }
    
    if(keyChar == NSLeftArrowFunctionKey){
        
        
        NSLog(@"Pressed LEFT");
        
        left = 2;
        
        [leftAXIS setIntegerValue:0];
        [ratioLEFT setStringValue:@"0%"];

    }
    
    if(keyChar == NSRightArrowFunctionKey){
        
        NSLog(@"Pressed RIGHT");
        
        right = 2;
        
        [rightAXIS setIntegerValue:0];
        [ratioRIGHT setStringValue:@"0%"];

    }

    NSLog(@"Return");

}

- (void)keyDown:(NSEvent *)theEvent {
    NSString *keyPressed = [theEvent charactersIgnoringModifiers];
    unichar keyChar = [keyPressed characterAtIndex:0];

    // if presse„d any arrow
    if(keyChar == NSUpArrowFunctionKey) {
        
        NSLog(@"Pressed UP");
        
        forward = 1;
        
        [upAXIS setIntegerValue:1];
        [ratioUP setStringValue:@"100%"];

    }
    
    if(keyChar == NSDownArrowFunctionKey){
        
        NSLog(@"Pressed DOWN");
        
        backward = 1;
        
        [downAXIS setIntegerValue:1];
        [ratioDOWN setStringValue:@"100%"];
        
    }
    
    if(keyChar == NSLeftArrowFunctionKey){
        
        NSLog(@"Pressed LEFT");
        
        left = 1;
        
        [leftAXIS setIntegerValue:1];
        [ratioLEFT setStringValue:@"100%"];
    }
    
    if(keyChar == NSRightArrowFunctionKey){
        
        NSLog(@"Pressed RIGHT");
        
        right = 1;
        
        [rightAXIS setIntegerValue:1];
        [ratioRIGHT setStringValue:@"100%"];
    }
 
}

-(IBAction)connect:(id)sender{
    
  
    [NSTimer scheduledTimerWithTimeInterval:rateCONf
                                     target:self
                                   selector:@selector(clock:)
                                   userInfo:nil
                                    repeats:YES];
    
    
    const char *serverIp = [[ipAddress stringValue] cStringUsingEncoding:NSASCIIStringEncoding];
    struct sockaddr_in serv_addr;
    struct hostent *server;

    
    
    if ( ( sockfd = socket(AF_INET, SOCK_STREAM, 0) ) < 0 ){
        
        NSLog(@"ERROR opening socket");
    }
    
    if ( ( server = gethostbyname( serverIp ) ) == NULL ){
        
        NSLog(@"ERROR, no such host\n");
        
    }else{
    
    [ipAddress setEnabled:NO];
    
    bzero( (char *) &serv_addr, sizeof(serv_addr));
    serv_addr.sin_family = AF_INET;
    bcopy( (char *)server->h_addr, (char *)&serv_addr.sin_addr.s_addr, server->h_length);
    serv_addr.sin_port = htons(portno);
    if ( connect(sockfd,(struct sockaddr *)&serv_addr,sizeof(serv_addr)) < 0)
    
    NSLog(@"ERROR connecting");
    
    sendData( sockfd, 9 );
  
    //close( sockfd );
    }
    
}

-(void)clock:(NSTimer *)timer {
    //do smth
    
    NSLog(@"%d", serialized_buff(forward, backward, left, right));
    
    sendData( sockfd, serialized_buff(forward, backward, left, right));
    
    NSLog(@"Forward: %i, Backward : %i, Left : %i, Right : %i", forward, backward, left, right);
    
    NSLog(@"Sending data");
}

@end
