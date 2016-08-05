//
//  MOSAction.m
//  MOS
//
// 
//  Copyright © 2016 DJI. All rights reserved.
//

#import "MOSAction.h"

@implementation MOSAction

- (instancetype)init
{
    self = [super init];
    if (self) {
        _key = @"N/A";
        _label = @"N/A";
        _information = @"";;
        _cmdID = @-1;
        _acks = NO;
        
    }
    return self;
}

- (instancetype)initWithJsonDictionary:(NSDictionary *)jsonDictionary
{
    self = [self init];
    if (self) {
        
        NSString *jsonKey = [jsonDictionary objectForKey:@"key"];
        if (jsonKey) {
            self.key = jsonKey;
        }

        NSString *jsonCommandLabel = [jsonDictionary objectForKey:@"label"];
        if (jsonCommandLabel) {
            self.label = jsonCommandLabel;
        }
        
        NSString *jsonCommandInfo = [jsonDictionary objectForKey:@"info"];
        if (jsonCommandInfo) {
            self.information = jsonCommandInfo;
        }
        
        NSString *jsonCmdID = [jsonDictionary objectForKey:@"cmd_id"];
        if (jsonCmdID) {
            unsigned int result = 0;
            NSScanner *scanner = [NSScanner scannerWithString:jsonCmdID];
            
            [scanner setScanLocation:2]; // bypass '0x' character
            [scanner scanHexInt:&result];
            
            self.cmdID = [NSNumber numberWithUnsignedInt:result];
        }
        
        NSNumber *jsonAck = [jsonDictionary objectForKey:@"ack"];
        if (jsonAck) {
            self.acks = [jsonAck boolValue];
        }

        
    }
    return self;

}

@end
