//
//  AssetPriceView.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import <UIKit/UIKit.h>
#import "Model/AssetPriceModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, AssetPriceViewFlowType) {
    AssetDetailFlow = 0,
    AssetListFlow = 1,
};

@interface AssetPriceView : UIView
- (void)configureWithPrice: (PriceModel *)model;
- (instancetype)initWithFlowType:(AssetPriceViewFlowType)flowType;
@end

NS_ASSUME_NONNULL_END
