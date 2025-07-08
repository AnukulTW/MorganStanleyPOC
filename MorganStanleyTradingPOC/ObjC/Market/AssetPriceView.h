//
//  AssetPriceView.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import <UIKit/UIKit.h>
#import "Model/AssetPriceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetPriceView : UIView
- (void)configureWithPrice: (PriceModel *)model;
@end

NS_ASSUME_NONNULL_END
