//
//  ActiveStockCardView.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import <UIKit/UIKit.h>
#import "Model/ActiveStockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActiveStockCardView : UIView
- (void)configureView:(ActiveStockModel *)model;
@end

NS_ASSUME_NONNULL_END
