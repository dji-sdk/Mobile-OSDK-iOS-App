//
//  MOSJSONDynamicController.h
//  MOS
//
// 
//  Copyright © 2016 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "MOSSection.h"

@interface MOSJSONDynamicController : UITableViewController

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) MOSSection *section;

@end
