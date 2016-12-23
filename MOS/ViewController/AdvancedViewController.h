//
//  AdvancedViewController.h
//  MOS
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface AdvancedViewController : UIViewController

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UISwitch *lidarLoggingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *collisionAvoidanceSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *trajectoryLidarLoggingSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *trajectoryCollisionAvoidanceSwitch;
@property (weak, nonatomic) IBOutlet UILabel *commandResultLabel;

- (IBAction)lidarLoggingGo:(id)sender;
- (IBAction)collisionAvoidanceGo:(id)sender;
- (IBAction)trajectoryGo:(id)sender;
- (void)go:(Byte) cmdId;

@end
