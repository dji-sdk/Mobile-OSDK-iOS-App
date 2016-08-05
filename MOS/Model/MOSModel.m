//
//  MOSModel.m
//  MOS
//
// 
//  Copyright © 2016 DJI. All rights reserved.
//

#import "MOSModel.h"
#import "MOSSection.h"

@implementation MOSModel

- (instancetype)init
{
    self = [super init];
    if (self) {
        _jsonSections = [NSMutableArray new];
        _logs = [NSMutableArray new];
    }
    return self;
}

/*********************************************************************************/
#pragma mark - JSON-Based UI
/*********************************************************************************/

- (void)loadConfiguration
{
    NSURL *configFileURL = [[NSBundle mainBundle] URLForResource:@"config" withExtension:@"json"];
    NSData *configFileContent = [NSData dataWithContentsOfURL:configFileURL];
    NSError *error = nil;
    NSDictionary *jsonConfigFile = [NSJSONSerialization JSONObjectWithData:configFileContent
                                                                   options:NSJSONReadingMutableContainers
                                                                     error:&error];
    
    if (error) {
        NSLog(@"Critical config.json parsing error:\n%@\n>>> UI won't load.", error);
    } else {
        [self.jsonSections removeAllObjects];
        
        NSArray *allKeys = jsonConfigFile.allKeys;
        NSInteger index = 0;
        
        for (index = 0; index < allKeys.count; index++)
        {            
            NSString *sectionName = [allKeys objectAtIndex:index];
            NSArray *jsonContent = [jsonConfigFile objectForKey:sectionName];
            MOSSection *newSection = [[MOSSection alloc] initWithName:sectionName andJSONContent:jsonContent];
            
            [self.jsonSections addObject:newSection];
        }
    }
}

/*********************************************************************************/
#pragma mark - Logs
/*********************************************************************************/

- (void)addLog:(NSString *)newLogEntry {
    [self.logs addObject:@{@"timestamp" : [NSDate date],
                           @"log":newLogEntry}];
    if (self.logChangedBlock) {
        self.logChangedBlock();
    }
}


@end
