//
//  MarketTopMoversViewController.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 09/07/25.
//

#import <UIKit/UIKit.h>
#import "MarketMoverModel.h"

typedef NSMutableDictionary<NSString*, NSArray<MarketMoverModel *> *> MarketMovers;

NS_ASSUME_NONNULL_BEGIN

@interface MarketMoversViewController : UIViewController
- (instancetype)initWithMarketGainer:(NSArray<MarketMoverModel *> *)marketGainer
                    withMarkketLoser:(NSArray<MarketMoverModel *> *)marketLosers;
@end

NS_ASSUME_NONNULL_END
