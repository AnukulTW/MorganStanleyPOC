//
//  MarketMovementView.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import <UIKit/UIKit.h>
#import "Model/MarketMoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarketMoverCardView : UIView
- (void)configureWithMarketMover:(MarketMoverModel *)model;
@end

NS_ASSUME_NONNULL_END
