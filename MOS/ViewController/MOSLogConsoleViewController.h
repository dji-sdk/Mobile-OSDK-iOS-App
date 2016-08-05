//
//  MOSLogConsoleViewController.h
//  MOS
//
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface MOSLogConsoleViewController : UIViewController

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) IBOutlet UITextView *logView;

- (void)updateLogView;

@end
