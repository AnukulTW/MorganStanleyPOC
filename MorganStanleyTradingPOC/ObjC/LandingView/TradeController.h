//
//  TradeController.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 08/07/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
@class AssetPriceModel

@protocol SymbolsHandler <NSObject>
- (void)fetchPrice:(AssetPriceModel *)model;
- (void)updateAssetLastQuote:(NSArray<AssetQuoteModel*> *)assetQuoteArray;
@end

@interface TradeController : NSObject
@property (nonatomic, weak) id<SymbolsHandler> handler;
@end
