//
//  MOSProductCommunicationManager.h
//  MOS
//
// 
//  Copyright © 2016 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>
@import DJISDK;
@class AppDelegate;

NS_ASSUME_NONNULL_BEGIN

typedef void (^MOSAckBlock)(NSData *data, NSError * _Nullable error);

@interface MOSProductCommunicationManager : NSObject <DJISDKManagerDelegate, DJIFlightControllerDelegate>

@property (weak, nonatomic) AppDelegate *appDelegate;
@property (weak, nonatomic) DJIBaseProduct *connectedProduct;
@property (strong, nonatomic) NSMutableDictionary *sentCmds;

/*********************************************************************************/
#pragma mark - OnBoardSDK Communication
/*********************************************************************************/

- (NSString *)commandIDStringKeyFromData:(NSData *)data;
- (void)sendData:(NSData *)data withCompletion:(void (^)(NSError * _Nullable error))completion andAckBlock:(MOSAckBlock)ackBlock;


@end

NS_ASSUME_NONNULL_END