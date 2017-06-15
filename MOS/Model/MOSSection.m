//
//  MOSSection.m
//  MOS
//
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import "MOSSection.h"
#import "MOSAction.h"

@implementation MOSSection

- (instancetype)init
{
    self = [super init];
    if (self) {
        _name = @"N/A";
        _actions = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithName:(NSString *)sectionName andJSONContent:(NSArray *)jsonContent
{
    self = [self init];
    if (self) {
        self.name = sectionName;
        self.actions = [self actionsInJsonArray:jsonContent];
    }
    return self;
}

- (NSMutableArray <MOSAction *> *)actionsInJsonArray:(NSArray *)jsonArray
{
    NSMutableArray *actions = [NSMutableArray new];
    
    NSInteger index = 0;
    for (index = 0; index < jsonArray.count; index++)
    {
        NSDictionary *jsonAction = [jsonArray objectAtIndex:index];
        
        MOSAction *action = [[MOSAction alloc] initWithJsonDictionary:jsonAction];
        if (action) {
            [actions addObject:action];
        }
    }
    
    return actions;
}


@end
