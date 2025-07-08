//
//  SocketConnectionManager.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import <Foundation/Foundation.h>
#import "AssetQuoteModel.h"


NS_ASSUME_NONNULL_BEGIN

@protocol SocketConnectionManagerDelegate <NSObject>
- (void)didReceivePrice:(AssetPriceModel *)priceModel forAsset:(NSString *)asset;
- (void)connectionEstablishSuccess;
@end


@interface SocketConnectionManager : NSObject
- (void)openSocketConnection;
@property (nonatomic, weak) id<SocketConnectionManagerDelegate> connectionDelegate;
- (void)subscribeAssets:(NSArray<NSString *>*)assets;
- (AssetPriceModel *)fetchPrice:(NSString *)assetName ;
- (void)updateAssetLastQuote:(NSArray<AssetQuoteModel*> *)assetQuoteArray;
@end

NS_ASSUME_NONNULL_END
