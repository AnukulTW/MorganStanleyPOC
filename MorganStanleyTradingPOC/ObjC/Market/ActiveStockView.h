//
//  ActiveStockView.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import <UIKit/UIKit.h>
#import "Model/ActiveStockModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface ActiveStockView : UIView
- (void)configureStockView:(NSArray<ActiveStockModel *> *)activeStocks;
@end

NS_ASSUME_NONNULL_END
