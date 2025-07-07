//
//  AssetPriceModel.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import <Foundation/Foundation.h>
#import "PriceModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetPriceModel : NSObject
@property(nonatomic, nonnull, strong,) PriceModel *bidPrice;
@property(nonatomic, nonnull, strong,) PriceModel *askPrice;

- (instancetype)initWithQuoteDictionary: (NSDictionary*) dict;

@end

NS_ASSUME_NONNULL_END
