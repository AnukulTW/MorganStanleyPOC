//
//  AssetDetailView.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 11/07/25.
//

#import <UIKit/UIKit.h>
#import "AssetPriceView.h"


NS_ASSUME_NONNULL_BEGIN

@interface AssetDetailView : UIView
- (void)configureWithPrice: (AssetPriceModel *)model;
@end

NS_ASSUME_NONNULL_END
