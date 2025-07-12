//
//  AssetDetailViewController.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 11/07/25.
//

#import <UIKit/UIKit.h>
#import "AssetPriceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetDetailViewController : UIViewController
- (instancetype)initWithAssetName:(NSString *)assetName priceModel: (AssetPriceModel *)model;
@end

NS_ASSUME_NONNULL_END
