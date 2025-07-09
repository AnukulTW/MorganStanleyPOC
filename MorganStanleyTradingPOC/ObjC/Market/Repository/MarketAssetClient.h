//
//  NewsClient.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//
#import <Foundation/Foundation.h>
#import "NetworkManaging.h"

@class AssetQuoteModel;

NS_ASSUME_NONNULL_BEGIN

@interface MarketAssetClient : NSObject

- (instancetype)initWithNetworkManager:(id<NetworkManaging>)networkManager;
- (void)fetchMarketAssetWithCompletion:(void (^)(NSArray<AssetQuoteModel *> * _Nullable result, NSArray<NSString *> * _Nullable list, NSError * _Nullable error))completion;
- (void)fetchLastQuoteForAsset:(NSArray<NSString *> *)symbols
                    completion:(void (^)(NSArray<AssetQuoteModel *> * _Nullable result, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
