//
//  MOSSection.h
//  MOS
//
// 
//  Copyright © 2016 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MOSAction;

@interface MOSSection : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSMutableArray <MOSAction *> *actions;

- (instancetype)initWithName:(NSString *)sectionName andJSONContent:(NSArray *)jsonContent;
- (NSMutableArray <MOSAction *> *)actionsInJsonArray:(NSArray *)jsonArray;


@end
