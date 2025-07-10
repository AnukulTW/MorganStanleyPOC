//
//  TopMarketMoverView.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import <UIKit/UIKit.h>
#import "MarketMoverModel.h"


@protocol MarketMoverActionDelegate <NSObject>
- (void)viewAllMarketMovers;
@end

NS_ASSUME_NONNULL_BEGIN

@interface MarketMoverView : UIView
@property (nonatomic, weak) id<MarketMoverActionDelegate> marketMoverDelegate;

- (void)configureMarketMovers:(NSArray<MarketMoverModel *> *)topGainers
                    topLosers:(NSArray<MarketMoverModel *> *) topLosers;
@end

NS_ASSUME_NONNULL_END
