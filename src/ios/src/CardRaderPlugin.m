#import "CardRaderPlugin.h"

#pragma mark -

@interface CardRaderPlugin ()

@property (nonatomic, copy, readwrite) NSString *callbackID;

- (void)sendSuccessTo:(NSString *)callbackId withObject:(id)objwithObject;
- (void)sendFailureTo:(NSString *)callbackId;

@end

#pragma mark -

@implementation CardRaderPlugin


- (void)execute:(CDVInvokedUrlCommand *)command {
	[super viewDidLoad];
	_reader = [[iMagRead alloc]init];
    [self start:command];
    [self stop:command];
}

- (void)start:(CDVInvokedUrlCommand *)command {
    self.scanCallbackId = command.callbackId;
    NSDictionary* options = [command.arguments objectAtIndex:0];
    NSString * CARREAD_MSG_ByteUpdate = @"CARREAD_MSG_ByteUpdate";
	NSString * CARREAD_MSG_BitUpdate  = @"CARREAD_MSG_BitUpdate";
	NSString * CARREAD_MSG_Err  = @"CARREAD_MSG_Err";
    
    [_reader Start];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateBytes:) name:CARREAD_MSG_ByteUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateBits:) name:CARREAD_MSG_BitUpdate object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UpdateError:) name:CARREAD_MSG_Err object:nil]; 
    
    NSMutableDictionary *response = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                     info.cardNumber, @"card_number",
                                     info.redactedCardNumber, @"redacted_card_number",
                                     [CardIOCreditCardInfo displayStringForCardType:info.cardType
                                                              usingLanguageOrLocale:self.paymentViewController.languageOrLocale],
                                     @"card_type",
                                     nil];
    if(info.expiryMonth > 0 && info.expiryYear > 0) {
        [response setObject:[NSNumber numberWithUnsignedInteger:info.expiryMonth] forKey:@"expiry_month"];
        [response setObject:[NSNumber numberWithUnsignedInteger:info.expiryYear] forKey:@"expiry_year"];
    }
    
    [self sendSuccessTo:self.scanCallbackId withObject:response];
}

- (void)stop:(CDVInvokedUrlCommand *)command {
	[_reader Stop];
    [self sendSuccessTo:command.callbackId withObject:[NSNumber numberWithBool:TRUE]];
}

- (void) UpdateBytes:(NSNotification*)aNotification{    
	NSString* str = [aNotification object];
	[self performSelectorOnMainThread:@selector(updateBytCtl:) withObject:str waitUntilDone:YES];
}

- (void) UpdateBits:(NSNotification*)aNotification{
	NSString* str = [aNotification object];
	[self performSelectorOnMainThread:@selector(updateBitCtl:) withObject:str waitUntilDone:YES];
}

- (void) UpdateError:(NSNotification*)aNotification{
	NSString* str = [aNotification object];
	[self performSelectorOnMainThread:@selector(updateErrorState:) withObject:str waitUntilDone:YES];
}

- (void) updateErrorState:(NSString*) text{
	static bool chang_color =false;
	if (chang_color) {
		[_errLable setTextColor:[UIColor blueColor]];
		chang_color=false;
	} else{
		[_errLable setTextColor:[UIColor blackColor]];
		chang_color=true;
	}
	if ([text isEqualToString:@"Sucess"]) {
		[_errLable setBackgroundColor:[UIColor greenColor]];
	} else 
	{        
		[_errLable setBackgroundColor:[UIColor redColor]];
	}    
	
	[_errLable setText:text];   
}


#pragma mark - Cordova callback helpers

- (void)sendSuccessTo:(NSString *)callbackId withObject:(id)obj {
    CDVPluginResult *result = nil;
    
    if([obj isKindOfClass:[NSString class]]) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:obj];
    } else if([obj isKindOfClass:[NSDictionary class]]) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:obj];
    } else if ([obj isKindOfClass:[NSNumber class]]) {
        // all the numbers we return are bools
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[obj intValue]];
    } else if(!obj) {
        result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    } else {
        NSLog(@"Success callback wrapper not yet implemented for class %@", [obj class]);
    }
    
    NSString *responseJavascript = [result toSuccessCallbackString:callbackId];
    if(responseJavascript) {
        [self writeJavascript:responseJavascript];
    }
}

- (void)sendFailureTo:(NSString *)callbackId {
    CDVPluginResult *result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    NSString *responseJavascript = [result toErrorCallbackString:callbackId];
    if(responseJavascript) {
        [self writeJavascript:responseJavascript];
    }
}

@end
