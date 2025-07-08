//
//  SocketConnectionManager 2.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 08/07/25.
//


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NativeSocketConnectionManagerDelegate <NSObject>
- (void)didReceiveMessage:(NSString *)message;
@end

@interface NativeSocketConnectionManager : NSObject

@property (nonatomic, weak) id<NativeSocketConnectionManagerDelegate> connectionDelegate;

- (void)connect;
- (void)disconnect;
- (void)sendMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
