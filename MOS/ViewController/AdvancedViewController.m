//
//  AdvancedViewController.m
//  MOS
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdvancedViewController.h"
#import "MOSModel.h"
#import "MOSProductCommunicationManager.h"

@interface AdvancedViewController ()

@end

@implementation AdvancedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)lidarLoggingGo:(id)sender {
    Byte cmdId = self.lidarLoggingSwitch.isOn ? 0x14 : 0x15;
    [self go:cmdId];
}

- (IBAction)collisionAvoidanceGo:(id)sender {
    Byte cmdId = self.collisionAvoidanceSwitch.isOn ? 0x16 : 0x17;
    [self go:cmdId];
}

- (IBAction)trajectoryGo:(id)sender {
    Byte cmdId;
    
    if (!self.trajectoryLidarLoggingSwitch.isOn && !self.trajectoryCollisionAvoidanceSwitch.isOn) cmdId=0x18;
    else if (!self.trajectoryLidarLoggingSwitch.isOn && self.trajectoryCollisionAvoidanceSwitch.isOn) cmdId=0x19;
    else if (self.trajectoryLidarLoggingSwitch.isOn && !self.trajectoryCollisionAvoidanceSwitch.isOn) cmdId=0x1A;
    else if (self.trajectoryLidarLoggingSwitch.isOn && self.trajectoryCollisionAvoidanceSwitch.isOn) cmdId=0x1B;
    
    [self go:cmdId];
}

- (void)go:(Byte) cmdId {
    NSData *data = [NSData dataWithBytes:&cmdId length:1];

    [self.appDelegate.model addLog:[NSString stringWithFormat:@"Sending CmdID %x", cmdId]];
    self.commandResultLabel.text = @"Sending...";
    [self.appDelegate.productCommunicationManager sendData:data
                                            withCompletion:^(NSError * _Nullable error) {
                                                [self.appDelegate.model addLog:[NSString stringWithFormat:@"Sent CmdID %x", cmdId]];
                                                self.commandResultLabel.text = @"Command Sent!";
                                            }
                                               andAckBlock:^(NSData * _Nonnull data, NSError * _Nullable error) {
                                                   
                                                   NSData *ackData = [data subdataWithRange:NSMakeRange(2, [data length] - 2)];
                                                   uint16_t ackValue;
                                                   [ackData getBytes:&ackValue length:sizeof(uint16_t)];
                                                   
                                                   NSString *responseMessage = [NSString stringWithFormat:@"Ack: %u", ackValue];
                                                   [self.appDelegate.model addLog:[NSString stringWithFormat:@"Received ACK [%@] for CmdID %x", responseMessage, cmdId]];
                                                   
                                                   self.commandResultLabel.text = responseMessage;
                                               }];
}

@end
