//
//  ThreadedSocketConnectionManager.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 09/07/25.
//

#import "SocketConnectionEnabler.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ThreadedSocketConnectionManagerDelegate <NSObject>
@required
- (void)didReceiveMessage:(NSString *)message;
- (void)connectionEstablishSuccess;
@end

@interface ThreadedSocketConnectionManager:NSObject <SocketConnectionEnabler,NSURLSessionDelegate>
@property (nonatomic, weak) id<ThreadedSocketConnectionManagerDelegate> connectionDelegate;

- (void)connect;
- (void)disconnect;
- (void)subscribeAssets:(NSArray<NSString *> *)assets;
@end
NS_ASSUME_NONNULL_END
