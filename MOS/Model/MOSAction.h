//
//  MOSAction.h
//  MOS
//
//  
//  Copyright © 2016 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOSAction : NSObject

@property (strong, nonatomic) NSString *key;
@property (strong, nonatomic) NSString *label;
@property (strong, nonatomic) NSString *information;
@property (strong, nonatomic) NSNumber *cmdID;
@property BOOL acks; // Acknowledgment

- (instancetype)initWithJsonDictionary:(NSDictionary *)jsonDictionary;

@end
