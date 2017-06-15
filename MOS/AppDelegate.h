//
//  AppDelegate.h
//  MOS
//
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MOSModel;
@class MOSProductCommunicationManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) MOSModel *model;
@property (strong, nonatomic) MOSProductCommunicationManager *productCommunicationManager;

@end

