//
//  MarketMovementAPIClient.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import <Foundation/Foundation.h>
#import "MarketMoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarketMovementAPIClient : NSObject
- (void)fetchTopMarketMovers:(void (^)(NSMutableDictionary<NSString* ,NSArray<MarketMoverModel*>* >* _Nullable , NSError* _Nullable))completion;
@end

NS_ASSUME_NONNULL_END
