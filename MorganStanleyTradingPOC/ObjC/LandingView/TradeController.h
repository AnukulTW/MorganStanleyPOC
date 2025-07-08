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
- (void)didReceivePrice:(AssetPriceModel *)priceModel forAsset:(NSString *)asset;
- (void)connectionEstablishSuccess;
@end
NS_ASSUME_NONNULL_END

NS_ASSUME_NONNULL_BEGIN
@interface TradeController : NSObject
@property (nonatomic, weak) id<SymbolsHandler> handler;
- (instancetype)initWithSocketEnabler:(id<SocketConnectionEnabler>)enabler;
- (void)subscribeAssets:(NSArray<NSString *>*)assets;
- (AssetPriceModel *)fetchPrice:(NSString *)assetName;
- (void)updateAssetLastQuote:(NSArray<AssetQuoteModel*> *)assetQuoteArray;
-(void) startSocket;
@end
NS_ASSUME_NONNULL_END
