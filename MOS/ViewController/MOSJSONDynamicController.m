//
//  MOSJSONDynamicController.m
//  MOS
//
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import "MOSJSONDynamicController.h"
#import "MOSModel.h"
#import "MOSAction.h"
#import "MOSDynamicTableViewCell.h"
#import "MOSProductCommunicationManager.h"

@implementation MOSJSONDynamicController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"MOSDynamicTableViewCell"
                                              bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:@"action"];
    self.tableView.estimatedRowHeight = 40;

    UIEdgeInsets currentEdgeInset = self.tableView.contentInset;
    self.tableView.contentInset = UIEdgeInsetsMake(20, currentEdgeInset.left, 50, currentEdgeInset.right);
    self.tableView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:.6];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.section.actions.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MOSDynamicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"action" forIndexPath:indexPath];
    MOSAction *action = self.section.actions[indexPath.row];

    [cell populateWithActionModel:action];
    
    __weak MOSDynamicTableViewCell *weakCell = cell;
    cell.goAction = ^(NSNumber *cmdId, NSArray *arguments) {
      
        // Arguments are not supported yet.
        u_int16_t cmdIdUInt = [cmdId unsignedIntValue];
        NSData *data = [NSData dataWithBytes:&cmdIdUInt length:sizeof(u_int16_t)];

        [self.appDelegate.model addLog:[NSString stringWithFormat:@"Sending CmdID %@ with %ld Arguments", cmdId, (unsigned long)arguments.count]];
        weakCell.commandResultLabel.text = @"Sending...";
        [self.appDelegate.productCommunicationManager sendData:data
                                                withCompletion:^(NSError * _Nullable error) {
                                                    [self.appDelegate.model addLog:[NSString stringWithFormat:@"Sent CmdID %@", cmdId]];
                                                    weakCell.commandResultLabel.text = @"Command Sent!";
                                                }
                                                   andAckBlock:^(NSData * _Nonnull data, NSError * _Nullable error) {
                                                       
                                                       NSData *ackData = [data subdataWithRange:NSMakeRange(2, [data length] - 2)];
                                                       uint16_t ackValue;
                                                       [ackData getBytes:&ackValue length:sizeof(uint16_t)];
                                                       
                                                       NSString *responseMessage = [NSString stringWithFormat:@"Ack: %u", ackValue];
                                                       [self.appDelegate.model addLog:[NSString stringWithFormat:@"Received ACK [%@] for CmdID %@", responseMessage, cmdId]];
                                                       
                                                       weakCell.commandResultLabel.text = responseMessage;
                                                   }];
    };

    return cell;
}

@end
