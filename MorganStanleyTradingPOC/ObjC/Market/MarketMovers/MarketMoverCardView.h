//
//  MarketMovementView.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import <UIKit/UIKit.h>
#import "MarketMoverModel.h"

typedef NS_ENUM(NSInteger, MarketMoverCardViewFlowType) {
    CardFlow = 0,
    CellFlow = 1,
};

NS_ASSUME_NONNULL_BEGIN

@interface MarketMoverCardView : UIView
- (instancetype)initWithFlowType:(MarketMoverCardViewFlowType)flowType;

- (void)configureWithMarketMover:(MarketMoverModel *)model
                 isTopGainerCard: (BOOL) isTopGainerCard;

- (void)configureWithMarketMover:(MarketMoverModel *)model;
@end

NS_ASSUME_NONNULL_END
