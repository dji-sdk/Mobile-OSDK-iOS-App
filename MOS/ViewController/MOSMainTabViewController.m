//
//  MOSMainTabViewController.m
//  MOS
//
// 
//  Copyright © 2016 DJI. All rights reserved.
//

#import "MOSMainTabViewController.h"
#import "MOSModel.h"
#import "MOSSection.h"
#import "MOSJSONDynamicController.h"
#import "MOSLogConsoleViewController.h"

@interface MOSMainTabViewController ()

@end

@implementation MOSMainTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    NSMutableArray *viewControllers = [NSMutableArray new];
    MOSJSONDynamicController *selectedViewController = nil;
    NSArray *allSections = [self.appDelegate.model jsonSections];
    NSUInteger index = 0;
    
    for (index = 0; index < allSections.count; index++)
    {
        MOSSection *section = allSections[index];
        MOSJSONDynamicController *newController = [[MOSJSONDynamicController alloc] initWithStyle:UITableViewStylePlain];
        newController.section = section;
        
        if (selectedViewController == nil) {
            selectedViewController = newController;
        }
        
        newController.tabBarItem = [[UITabBarItem alloc] initWithTitle:section.name
                                                                 image:[UIImage imageNamed:@"first"]
                                                                   tag:index];
        newController.title = section.name;
        [viewControllers addObject:newController];
    }

    // Adding the log view
    MOSLogConsoleViewController *logVC = [[MOSLogConsoleViewController alloc] initWithNibName:@"MOSLogConsoleViewController" bundle:[NSBundle mainBundle]];
    logVC.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"Logs"
                                                     image:[UIImage imageNamed:@"second"]
                                                       tag:index+1];
    logVC.title = @"Logs";
    [viewControllers addObject:logVC];
    
    [self.appDelegate.model addLog:@"Created UI"];
    
    [self setViewControllers:viewControllers];
    self.selectedViewController = selectedViewController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
