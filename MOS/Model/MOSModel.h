//
//  MOSModel.h
//  MOS
//
//
//  Copyright © 2016 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  MOSSection;

typedef void(^MOSModelLogChangedBlock)();

@interface MOSModel : NSObject

/*********************************************************************************/
#pragma mark - JSON-Based UI
/*********************************************************************************/

@property (strong, nonatomic) NSMutableArray <MOSSection *> *jsonSections;

// Loads the config.json file.
- (void)loadConfiguration;

/*********************************************************************************/
#pragma mark - Logs
/*********************************************************************************/
@property (strong, nonatomic) NSMutableArray <NSDictionary *> *logs;
@property (strong, nonatomic) MOSModelLogChangedBlock logChangedBlock;

- (void)addLog:(NSString *)newLogEntry;

@end
