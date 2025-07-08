//
//  SocketConnectionManager.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import <Foundation/Foundation.h>
#import "AssetQuoteModel.h"
#import "SocketConnectionEnabler.h"
NS_ASSUME_NONNULL_BEGIN

//@protocol SocketConnectionManagerDelegate <NSObject>
//- (void)didReceivePrice:(AssetPriceModel *)priceModel forAsset:(NSString *)asset;
//- (void)connectionEstablishSuccess;
//@end


@interface SocketConnectionManager : NSObject <SocketConnectionEnabler>
@property (nonatomic, weak) id<SocketConnectionManagerDelegate> connectionDelegate;
- (void)subscribeAssets:(NSArray<NSString *>*)assets;
@end

NS_ASSUME_NONNULL_END
