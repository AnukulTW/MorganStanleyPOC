//
//  SocketConnectionEnabler.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 08/07/25.
//

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

@protocol SocketConnectionManagerDelegate <NSObject>
- (void)didReceiveMessage:(id)message;
- (void)connectionEstablishSuccess;
@end

@protocol SocketConnectionEnabler <NSObject>
@property (nonatomic, weak) id<SocketConnectionManagerDelegate> connectionDelegate;
- (void)subscribeAssets:(NSArray<NSString *>*)assets;
- (void)authenticateWebSocketConnection;
- (NSDictionary *)authDictionary;
- (NSDictionary *)livePriceSubcriptionDictionary: (NSArray<NSString *> *)assets;
- (NSURL *)createURL;
- (void)sendMessage:(NSString *)message;
- (void)reconnect;
- (void)disconnect;
- (void)receiveMessages;
- (void)connect;
@end

@protocol TradeDataKeysProvider <NSObject>
- (NSString *)assetNameKey;
- (NSString *)bidPriceKey;
- (NSString *)askPriceKey;
@end



NS_ASSUME_NONNULL_END
