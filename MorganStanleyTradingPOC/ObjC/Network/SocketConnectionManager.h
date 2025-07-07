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
- (void)didReceivePrice:(NSString *)price forAsset:(NSString *)asset;
@end


@interface SocketConnectionManager : NSObject
@property (nonatomic, weak) id<SocketConnectionManagerDelegate> connectionDelegate;
- (void)subscribeAssets:(NSArray<NSString *>*)assets;
- (NSString *)fetchPrice:(NSString *)assetName;
- (void)updateAssetLastQuote:(NSArray<AssetQuoteModel*> *)assetQuoteArray;
@end

NS_ASSUME_NONNULL_END
