#import <Cordova/CDV.h>
#import "iMagRead.h"

@interface ViewController : UIViewController{iMagRead * _reader;}

@interface CardRaderPlugin : CDVPlugin {
   NSString* callbackID;
}

- (void)execute:(CDVInvokedUrlCommand *) command;
- (void)start:(CDVInvokedUrlCommand *)command;
- (void)stop:(CDVInvokedUrlCommand *)command;

@end
