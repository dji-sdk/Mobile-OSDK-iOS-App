//
//  MOSMainScreenViewController.h
//  MOS
//
//  Created by RussFenenga on 7/18/17.
//  Copyright © 2017 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MOSSection.h"
#import "MOSConstants.h"
@import DJIUILibrary;

@interface MOSMainScreenViewController : UIViewController

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) MOSSection *section;

@end
