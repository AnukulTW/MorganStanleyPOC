//
//  MarketMoversTableViewCell.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 10/07/25.
//

#import <UIKit/UIKit.h>
#import "MarketMoverModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MarketMoversTableViewCell : UITableViewCell
- (void)configureWithMarketMover:(MarketMoverModel *)model;
@end

NS_ASSUME_NONNULL_END
