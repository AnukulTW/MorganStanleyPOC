//
//  MarketMovementAPIClient.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import <Foundation/Foundation.h>
#import "MarketMoverModel.h"
#import "ActiveStockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarketMovementAPIClient : NSObject
- (void)fetchMarketTopMovers:(void (^)(NSMutableDictionary<NSString* ,NSArray<MarketMoverModel*>* >* _Nullable , NSError* _Nullable))completion;
- (void)fetchActiveStocks:(void (^)(NSArray<ActiveStockModel*>*  _Nullable, NSError* _Nullable))completion;
@end

NS_ASSUME_NONNULL_END
