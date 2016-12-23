//
//  MOSProductCommunicationManager.m
//  MOS
//
// 
//  Copyright © 2016 DJI. All rights reserved.
//

#import "MOSProductCommunicationManager.h"
#import "AppDelegate.h"
#import "MOSModel.h"

@implementation MOSProductCommunicationManager

- (instancetype)init
{
    self = [super init];
    if (self) {
        _sentCmds = [NSMutableDictionary new];
        _appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        [self registerWithProduct];
    }
    return self;
}

- (void)registerWithProduct {
    NSString *registrationID = @"1234EnterRegistrationIDhere";
    
    [self.appDelegate.model addLog:[NSString stringWithFormat:@"Registering Product with ID: %@", registrationID]];
    [DJISDKManager registerApp:registrationID withDelegate:self];
}

/*********************************************************************************/
#pragma mark - OnBoardSDK Communication
/*********************************************************************************/

- (NSString *)commandIDStringKeyFromData:(NSData *)data {
    uint16_t cmdId;
    [data getBytes:&cmdId length:sizeof(uint16_t)];
    NSString *key = [NSString stringWithFormat:@"%d", cmdId];
    
    return key;
}

- (void)sendData:(NSData *)data withCompletion:(void (^)(NSError * _Nullable error))completion andAckBlock:(MOSAckBlock)ackBlock
{
    DJIFlightController *fc = (DJIFlightController *)self.connectedProduct.components[DJIFlightControllerComponentKey][0];
    
    fc.delegate = self;
    
    [fc sendDataToOnboardSDKDevice:data withCompletion:^(NSError * _Nullable error) {
        if (error) {
            // Handle error locally
        } else {
            NSString *key = [self commandIDStringKeyFromData:data];
            
            [self.sentCmds setObject:ackBlock forKey:key];
        }
        completion(error);
    }];
}

/*********************************************************************************/
#pragma mark - DJIFlightControllerDelegate
/*********************************************************************************/

- (void)flightController:(DJIFlightController *_Nonnull)fc didReceiveDataFromExternalDevice:(NSData *_Nonnull)data
{
    NSString *key = [self commandIDStringKeyFromData:data];
    MOSAckBlock ackBlock = [self.sentCmds objectForKey:key];
    
    [self.appDelegate.model addLog:[NSString stringWithFormat:@"Received data from FC [%@]", data]];

    // Error handling is not supported yet.
    if (ackBlock) {
        ackBlock(data, nil);
    } else {
        [self.appDelegate.model addLog:[NSString stringWithFormat:@"Received Non-ACK data [%@]", data]];
    }
    [self.sentCmds removeObjectForKey:key];
}


/*********************************************************************************/
#pragma mark - DJISDKManagerDelegate
/*********************************************************************************/

- (void)sdkManagerDidRegisterAppWithError:(NSError *)error {
    
    //        NSString *debugID = @"10.128.129.110";
    //
    //        [self.appDelegate.model addLog:[NSString stringWithFormat:@"Connecting to Product using DebugID: %@", debugID]];
    //        [DJISDKManager enterDebugModeWithDebugId:debugID];
    
    if (error) {
        [self.appDelegate.model addLog:[NSString stringWithFormat:@"Error registering App: %@", error]];
    } else {
        [self.appDelegate.model addLog:@"Registration Succeeded"];

        [self.appDelegate.model addLog:@"Connecting to Product"];
        BOOL startedResult = [DJISDKManager startConnectionToProduct];
        
        if (startedResult) {
            [self.appDelegate.model addLog:@"Connecting to Product started successfully"];
        } else {
            [self.appDelegate.model addLog:@"Connecting to Product failed to start"];
        }
    }
}

- (void)sdkManagerProductDidChangeFrom:(DJIBaseProduct *)oldProduct to:(DJIBaseProduct *)newProduct {
    [self.appDelegate.model addLog:@"Connection to product Changed"];
    
    if (newProduct) {
        [self.appDelegate.model addLog:@"Connection to new product succeeded"];
        self.connectedProduct = newProduct;
    } else {
        [self.appDelegate.model addLog:@"Disconnected from product"];
    }
}

@end
