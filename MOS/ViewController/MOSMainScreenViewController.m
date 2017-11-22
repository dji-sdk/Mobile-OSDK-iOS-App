//
//  MOSMainScreenViewController.m
//  MOS
//
//  Created by RussFenenga on 7/18/17.
//  Copyright © 2017 DJI. All rights reserved.
//

#import "MOSMainScreenViewController.h"
#import <VideoPreviewer/VideoPreviewer.h>
#import "MOSJSONDynamicController.h"
#import "MOSModel.h"
#import "MOSLogConsoleViewController.h"
#import "MOSSectionButton.h"
#import "MOSProductCommunicationManager.h"

@interface MOSMainScreenViewController () <DJIVideoFeedListener, DJICameraDelegate, UIGestureRecognizerDelegate>

@property (weak, nonatomic) IBOutlet DULFPVView *fpvView;
@property (strong, nonatomic) DULCameraSettingsMenu *cameraSettingsMenuButton;

@property (strong, nonatomic) DULExposureSettingsMenu *cameraExposureWidget;

@property (strong, nonatomic) DULExposureSettingsController *cameraExposureController;
@property (strong, nonatomic) DULCameraSettingsController *cameraSettingsController;
@property (strong, nonatomic) DULStatusBarViewController *statusBarViewController;
@property (strong, nonatomic) DULDashboardWidget *dashboardWidget;

@property (strong, nonatomic) MOSLogConsoleViewController *logViewController;
//modify this for animating the Log view up and down.
@property (strong, nonatomic) NSLayoutConstraint *logViewDisplayConstraint;

@property (strong, nonatomic) MOSJSONDynamicController *currentActionMenu;
@property (strong, nonatomic) MOSSectionButton *currentlyActiveButton;

@property (strong,nonatomic) UIStackView *onboardSDKFunctionalityButtons;

@end

@implementation MOSMainScreenViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    [self setupStatusBar];
    [self setupStackView];
    [self setupDashBoard];
    [self setupLogger];
    [self setupGestures];
    [self setupCameraSettingsButtons];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    __weak MOSMainScreenViewController *weakSelf = self;
    DJIKeyManager *keyManager = [DJISDKManager keyManager];
    DJICameraKey *cameraKey = [DJICameraKey keyWithParam:DJIParamConnection];
    
    [keyManager startListeningForChangesOnKey:cameraKey withListener:self andUpdateBlock:^(DJIKeyedValue * _Nullable oldValue, DJIKeyedValue * _Nullable newValue) {
        if (newValue.boolValue == YES) {
            [weakSelf setupCamera];
            [weakSelf setupVideoPreviewer];
        } else {
            [weakSelf resetCamera];
            [weakSelf resetVideoPreview];
        }
    }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    DJIKeyManager *keyManager = [DJISDKManager keyManager];
    [self resetCamera];
    [self resetVideoPreview];
    [keyManager stopAllListeningOfListeners:self];
}

#pragma mark Helper Methods For View Setups

- (void)setupCameraSettingsButtons
{
    __weak MOSMainScreenViewController *weakSelf = self;

    //camerasettingsmenu
    self.cameraSettingsMenuButton = [[DULCameraSettingsMenu alloc] init];
    self.cameraSettingsMenuButton.translatesAutoresizingMaskIntoConstraints = NO;
    
    self.cameraSettingsMenuButton.action = ^{
        [weakSelf menuButtonPressed];
    };
    
    [self.fpvView addSubview:self.cameraSettingsMenuButton];
    [self.cameraSettingsMenuButton.trailingAnchor constraintEqualToAnchor:self.fpvView.trailingAnchor].active = YES;
    [self.cameraSettingsMenuButton.topAnchor constraintEqualToAnchor:self.statusBarViewController.view.bottomAnchor constant:5].active = YES;
    if (iPad) {
        [self.cameraSettingsMenuButton.widthAnchor constraintEqualToAnchor:self.cameraSettingsMenuButton.widthAnchor multiplier:0.2 constant:60].active = YES;
        [self.cameraSettingsMenuButton.heightAnchor constraintEqualToAnchor:self.cameraSettingsMenuButton.heightAnchor multiplier:0.2 constant:36].active = YES;
    } else {
        [self.cameraSettingsMenuButton.widthAnchor constraintEqualToAnchor:self.cameraSettingsMenuButton.widthAnchor multiplier:0.2 constant:50].active = YES;
        [self.cameraSettingsMenuButton.heightAnchor constraintEqualToAnchor:self.cameraSettingsMenuButton.heightAnchor multiplier:0.2 constant:30].active = YES;

    }
    
    self.cameraExposureWidget = [[DULExposureSettingsMenu alloc] init];
    self.cameraExposureWidget.translatesAutoresizingMaskIntoConstraints = NO;
    
    //exposuresettings
    self.cameraExposureWidget.action = ^{
        [weakSelf cameraExposureWidgetAction];
    };
    
    [self.fpvView addSubview:self.cameraExposureWidget];
    [self.cameraExposureWidget.trailingAnchor constraintEqualToAnchor:self.fpvView.trailingAnchor constant:-5].active = YES;
    [self.cameraExposureWidget.topAnchor constraintEqualToAnchor:self.cameraSettingsMenuButton.bottomAnchor constant:5].active = YES;
    if (iPad) {
        [self.cameraExposureWidget.widthAnchor constraintEqualToAnchor:self.cameraExposureWidget.widthAnchor multiplier:0.2 constant:30].active = YES;
        [self.cameraExposureWidget.heightAnchor constraintEqualToAnchor:self.cameraExposureWidget.heightAnchor multiplier:0.2 constant:40.4].active = YES;
    } else {
        [self.cameraExposureWidget.widthAnchor constraintEqualToAnchor:self.cameraExposureWidget.widthAnchor multiplier:0.2 constant:26].active = YES;
        [self.cameraExposureWidget.heightAnchor constraintEqualToAnchor:self.cameraExposureWidget.heightAnchor multiplier:0.2 constant:30].active = YES;
    }
}

- (void)setupDashBoard
{
    self.dashboardWidget = [[DULDashboardWidget alloc] init];
    self.dashboardWidget.translatesAutoresizingMaskIntoConstraints = NO;
    [self.fpvView insertSubview:self.dashboardWidget belowSubview:self.onboardSDKFunctionalityButtons];
    if (iPad) {
        [self.dashboardWidget.widthAnchor constraintEqualToAnchor:self.dashboardWidget.widthAnchor multiplier:0.2 constant:279].active = YES;
        [self.dashboardWidget.heightAnchor constraintEqualToAnchor:self.dashboardWidget.heightAnchor multiplier:0.2 constant:48.5].active = YES;
    } else {
        [self.dashboardWidget.widthAnchor constraintEqualToAnchor:self.dashboardWidget.widthAnchor multiplier:0.2 constant:200].active = YES;
        [self.dashboardWidget.heightAnchor constraintEqualToAnchor:self.dashboardWidget.heightAnchor multiplier:0.2 constant:34.8].active = YES;
    }
    
    [self.dashboardWidget.leadingAnchor constraintEqualToAnchor:self.onboardSDKFunctionalityButtons.trailingAnchor constant:10].active = YES;
    [self.dashboardWidget.bottomAnchor constraintEqualToAnchor:self.fpvView.bottomAnchor].active = YES;
}

- (void)setupStackView
{
    self.onboardSDKFunctionalityButtons = [[UIStackView alloc] init];
    self.onboardSDKFunctionalityButtons.axis = UILayoutConstraintAxisVertical;
    self.onboardSDKFunctionalityButtons.distribution = UIStackViewDistributionFillEqually;
    self.onboardSDKFunctionalityButtons.alignment = UIStackViewAlignmentCenter;
    self.onboardSDKFunctionalityButtons.spacing = 5.0;
    
    NSArray *allSections = [self.appDelegate.model jsonSections];
    NSUInteger index = 0;
    //generate the buttons dynamical based off the contents of the config.json
    for (index = 0; index < allSections.count; index++) {
        MOSSection *section = allSections[index];
        MOSSectionButton *sectionButton = [[MOSSectionButton alloc] initWithSection:section];
        
        [sectionButton addTarget:self action:@selector(sectionButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.onboardSDKFunctionalityButtons addArrangedSubview:sectionButton];
        [sectionButton.widthAnchor constraintEqualToAnchor:self.onboardSDKFunctionalityButtons.widthAnchor].active = YES;
    }
    
    self.onboardSDKFunctionalityButtons.translatesAutoresizingMaskIntoConstraints = NO;
    [self.fpvView addSubview:self.onboardSDKFunctionalityButtons];
    
    [self.onboardSDKFunctionalityButtons.bottomAnchor constraintEqualToAnchor:self.fpvView.bottomAnchor].active = YES;
    [self.onboardSDKFunctionalityButtons.topAnchor constraintEqualToAnchor:self.statusBarViewController.view.bottomAnchor].active = YES;
    [self.onboardSDKFunctionalityButtons.leadingAnchor constraintEqualToAnchor:self.fpvView.leadingAnchor].active = YES;
    [self.onboardSDKFunctionalityButtons.centerYAnchor constraintEqualToAnchor:self.fpvView.centerYAnchor].active = YES;
    [self.onboardSDKFunctionalityButtons.widthAnchor constraintEqualToAnchor:self.fpvView.widthAnchor multiplier:.10].active = YES;
    [self.onboardSDKFunctionalityButtons.heightAnchor constraintEqualToAnchor:self.fpvView.heightAnchor].active = YES;
}

- (void)setupGestures
{
    UISwipeGestureRecognizer *upSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(upSwipe)];
    [upSwipe setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.fpvView addGestureRecognizer:upSwipe];
    
    UISwipeGestureRecognizer *downSwipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(downSwipe)];
    [downSwipe setDirection:UISwipeGestureRecognizerDirectionDown];
    [self.fpvView addGestureRecognizer:downSwipe];
    
}

- (void)setupLogger
{
    self.logViewController = [[MOSLogConsoleViewController alloc] init];
    [self.logViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.fpvView addSubview:self.logViewController.view];
    
    [self.logViewController.view.leadingAnchor constraintEqualToAnchor:self.onboardSDKFunctionalityButtons.trailingAnchor].active = YES;
    [self.logViewController.view.trailingAnchor constraintEqualToAnchor:self.fpvView.trailingAnchor].active = YES;
    [self.logViewController.view.heightAnchor constraintEqualToAnchor:self.fpvView.heightAnchor].active = YES;
    //set the constraint of the top of logview to be the bottom of the fpv view offset by the height of the arrow icon.
    self.logViewDisplayConstraint = [self.logViewController.view.topAnchor constraintEqualToAnchor:self.fpvView.bottomAnchor constant: -36];
    self.logViewDisplayConstraint.active = YES;
    
}

- (void)setupStatusBar
{
    self.statusBarViewController = [[DULStatusBarViewController alloc] init];
    [self.statusBarViewController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view insertSubview: self.statusBarViewController.view aboveSubview:self.fpvView];
    ((DULWidgetCollectionViewLayout *)self.statusBarViewController.statusBarView.collectionViewLayout).minimumInteritemSpacing = 15;
    [self.statusBarViewController.view.leadingAnchor constraintEqualToAnchor:self.view.leadingAnchor].active = YES;
    [self.statusBarViewController.view.topAnchor constraintEqualToAnchor:self.view.topAnchor].active = YES;
    [self.statusBarViewController.view.trailingAnchor constraintEqualToAnchor:self.view.trailingAnchor].active = YES;
    [self.statusBarViewController.view.centerXAnchor constraintEqualToAnchor:self.view.centerXAnchor].active = YES;
    if (iPad) {
        [self.statusBarViewController.view.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.05].active = YES;
    } else {
        [self.statusBarViewController.view.heightAnchor constraintEqualToAnchor:self.view.heightAnchor multiplier:0.08].active = YES;
    }
}

- (void)setupCamera {
    DJICamera *camera = [self fetchCamera];
    if (camera != nil) {
        camera.delegate = self;
    }
}

- (void)resetCamera {
    DJICamera *camera = [self fetchCamera];
    if (camera && camera.delegate == self) {
        [camera setDelegate:nil];
    }
}

- (DJICamera*) fetchCamera {
    if (!self.appDelegate.productCommunicationManager.connectedProduct) {
        return nil;
    }
    if ([self.appDelegate.productCommunicationManager.connectedProduct isKindOfClass:[DJIAircraft class]]) {
        return ((DJIAircraft*)self.appDelegate.productCommunicationManager.connectedProduct).camera;
    } else if ([self.appDelegate.productCommunicationManager.connectedProduct isKindOfClass:[DJIHandheld class]]){
        return ((DJIHandheld *)self.appDelegate.productCommunicationManager.connectedProduct).camera;
    }
    return nil;
}

- (void)setupVideoPreviewer {
    
    [[VideoPreviewer instance] setView:self.fpvView];
    [[VideoPreviewer instance] setType:VideoPreviewerTypeAutoAdapt];
    DJIBaseProduct *product = self.appDelegate.productCommunicationManager.connectedProduct;
    if ([product.model isEqual:DJIAircraftModelNameA3] ||
        [product.model isEqual:DJIAircraftModelNameN3] ||
        [product.model isEqual:DJIAircraftModelNameMatrice600] ||
        [product.model isEqual:DJIAircraftModelNameMatrice600Pro]){
        [[DJISDKManager videoFeeder].secondaryVideoFeed addListener:self withQueue:nil];
    } else {
        [[DJISDKManager videoFeeder].primaryVideoFeed addListener:self withQueue:nil];
    }
    [[VideoPreviewer instance] start];
}

- (void)resetVideoPreview {
    [[VideoPreviewer instance] unSetView];
    DJIBaseProduct *product = self.appDelegate.productCommunicationManager.connectedProduct;
    if ([product.model isEqual:DJIAircraftModelNameA3] ||
        [product.model isEqual:DJIAircraftModelNameN3] ||
        [product.model isEqual:DJIAircraftModelNameMatrice600] ||
        [product.model isEqual:DJIAircraftModelNameMatrice600Pro]){
        [[DJISDKManager videoFeeder].secondaryVideoFeed removeListener:self];
    } else {
        [[DJISDKManager videoFeeder].primaryVideoFeed removeListener:self];
    }
}

#pragma mark - DJIVideoFeedListener
- (void)videoFeed:(DJIVideoFeed *)videoFeed didUpdateVideoData:(NSData *)videoData {
    [[VideoPreviewer instance] push:(uint8_t *)videoData.bytes length:(int)videoData.length];
}

- (void)presentMenuForSection: (MOSSection *)section
{
    if (!self.currentActionMenu) {
        self.currentActionMenu = [[MOSJSONDynamicController alloc] initWithStyle:UITableViewStylePlain];
        self.currentActionMenu.section = section;

        [self.currentActionMenu.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.fpvView insertSubview:self.currentActionMenu.view aboveSubview:self.logViewController.view];
        
        [self.currentActionMenu.view.bottomAnchor constraintEqualToAnchor:self.fpvView.bottomAnchor constant:-5].active = YES;
        [self.currentActionMenu.view.topAnchor constraintEqualToAnchor:self.statusBarViewController.view.bottomAnchor constant:5].active = YES;
        [self.currentActionMenu.view.leadingAnchor constraintEqualToAnchor:self.onboardSDKFunctionalityButtons.trailingAnchor constant: 15].active = YES;
        [self.currentActionMenu.view.widthAnchor constraintEqualToAnchor:self.fpvView.widthAnchor multiplier:0.20].active = YES;
    } else {
        self.currentActionMenu.section = section;
        [self.currentActionMenu.tableView reloadData];
    }
}

- (void)showAlertViewWithMessage:(NSString *)message
{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertController* alertViewController = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertViewController addAction:okAction];
        UIViewController *rootViewController = [[UIApplication sharedApplication] keyWindow].rootViewController;
        [rootViewController presentViewController:alertViewController animated:YES completion:nil];
    });
}

- (void)cameraExposureWidgetAction
{
    if (!self.cameraExposureController) {
        self.cameraExposureController = [[DULExposureSettingsController alloc] init];
        [self.cameraExposureController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.fpvView insertSubview:self.cameraExposureController.view aboveSubview:self.logViewController.view];
        [self.cameraExposureController.view.trailingAnchor constraintEqualToAnchor:self.cameraExposureWidget.leadingAnchor constant:-5].active = YES;
        [self.cameraExposureController.view.topAnchor constraintEqualToAnchor:self.cameraSettingsMenuButton.bottomAnchor constant:5].active = YES;
        [self.cameraExposureController.view.widthAnchor constraintEqualToAnchor:self.fpvView.widthAnchor multiplier:0.20].active = YES;
        [self.cameraExposureController.view.heightAnchor constraintEqualToAnchor:self.fpvView.heightAnchor multiplier:0.50].active = YES;
        self.cameraExposureController.view.hidden = NO;
        self.cameraSettingsController.view.hidden = YES;
    } else if (self.cameraExposureController.view.hidden) {
        self.cameraExposureController.view.hidden = NO;
        if (!self.cameraSettingsController.view.hidden) {
            self.cameraSettingsController.view.hidden = YES;
        }
    } else {
        self.cameraExposureController.view.hidden = YES;
    }
}

#pragma mark Selector For MOSSectionButtons
- (void)sectionButtonPressed:(MOSSectionButton *)sender
{
    if (sender.active == NO) {
        sender.active = YES;
        if (self.currentlyActiveButton) {
            self.currentlyActiveButton.backgroundColor = [UIColor colorWithRed:0 green:0 blue: 0 alpha:.4];
            self.currentlyActiveButton.active = NO;
        }
        self.currentlyActiveButton = sender;
        sender.backgroundColor = [UIColor colorWithRed:0 green:0 blue:.5 alpha:.4];
        if (self.currentActionMenu) {
            self.currentActionMenu.view.hidden = NO;
        }
        [self presentMenuForSection:sender.section];
        
    } else {
        sender.backgroundColor = [UIColor colorWithRed:0 green:0 blue: 0 alpha:.4];
        sender.active = NO;
        self.currentActionMenu.view.hidden = YES;
        self.currentlyActiveButton = nil;
    }
}

#pragma mark Selectors For Gesture Recognizers
- (void)upSwipe
{
    [self.fpvView removeConstraint:self.logViewDisplayConstraint];
    self.logViewDisplayConstraint = [self.logViewController.view.topAnchor constraintEqualToAnchor:self.fpvView.topAnchor constant:self.statusBarViewController.view.frame.size.height];
    self.logViewDisplayConstraint.active = YES;
    [UIView animateWithDuration: 0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.fpvView layoutIfNeeded];
    } completion: nil];
    
}

- (void)downSwipe
{
    [self.fpvView removeConstraint:self.logViewDisplayConstraint];
    self.logViewDisplayConstraint = [self.logViewController.view.topAnchor constraintEqualToAnchor:self.fpvView.bottomAnchor constant: -36];
    self.logViewDisplayConstraint.active = YES;
    [UIView animateWithDuration: 0.6 delay:0 usingSpringWithDamping:1 initialSpringVelocity:10 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self.fpvView layoutIfNeeded];
    } completion: nil];
}

- (void)menuButtonPressed{
    if (!self.cameraSettingsController) {
        self.cameraSettingsController = [[DULCameraSettingsController alloc] init];
        [self.cameraSettingsController.view setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.fpvView addSubview:self.cameraSettingsController.view];
        
        [self.cameraSettingsController.view.trailingAnchor constraintEqualToAnchor:self.cameraSettingsMenuButton.leadingAnchor constant:-5].active = YES;
        [self.cameraSettingsController.view.topAnchor constraintEqualToAnchor:self.statusBarViewController.view.bottomAnchor constant:5].active = YES;
        [self.cameraSettingsController.view.widthAnchor constraintEqualToAnchor:self.fpvView.widthAnchor multiplier:0.30].active = YES;
        [self.cameraSettingsController.view.heightAnchor constraintEqualToAnchor:self.fpvView.heightAnchor multiplier:0.50].active = YES;
        self.cameraSettingsController.view.hidden = NO;
        self.cameraExposureController.view.hidden = YES;
    } else if (self.cameraSettingsController.view.hidden) {
        self.cameraSettingsController.view.hidden = NO;
        self.cameraExposureController.view.hidden = YES;
    } else {
        self.cameraSettingsController.view.hidden = YES;
    }
}
@end
