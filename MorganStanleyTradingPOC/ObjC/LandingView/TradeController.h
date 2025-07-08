//
//  TradeController.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 08/07/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AssetPriceModel;
@class AssetQuoteModel;
@protocol SymbolsHandler <NSObject>
- (void)updateAssetLastQuote:(NSArray<AssetQuoteModel*> *)assetQuoteArray;
- (void)didReceivePrice:(AssetPriceModel *)priceModel forAsset:(NSString *)asset;
@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
@interface TradeController : NSObject
@property (nonatomic, weak) id<SymbolsHandler> handler;
- (void)subscribeAssets:(NSArray<NSString *>*)assets;
- (AssetPriceModel *)fetchPrice:(NSString *)assetName;
@end
NS_ASSUME_NONNULL_END
