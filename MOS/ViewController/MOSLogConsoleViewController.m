//
//  MOSLogConsoleViewController.m
//  MOS
//
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import "MOSLogConsoleViewController.h"
#import "MOSModel.h"

@interface MOSLogConsoleViewController ()

@end

@implementation MOSLogConsoleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    self.appDelegate.model.logChangedBlock = ^{
        [self updateLogView];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self updateLogView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)updateLogView {
    NSString *fullLog = @"";
    
    NSInteger index = 0;
    NSArray *logs = self.appDelegate.model.logs;
    for (index = logs.count -1; index+1; index--) {
        NSDictionary *logEntry = logs[index];
        NSDate *timestamp = logEntry[@"timestamp"];
        NSString *log = logEntry[@"log"];
        
        fullLog = [fullLog stringByAppendingFormat:@"%@ - %@\n", timestamp, log];
    }

    self.logView.text = fullLog;
}

@end
