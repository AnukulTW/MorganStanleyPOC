//
//  AssetPriceModel.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetPriceModel : NSObject
@property(nonatomic, assign) Float32 bidPrice;
@property(nonatomic, assign) Float32 askPrice;

- (instancetype)initWithQuoteDictionary: (NSDictionary*) dict;

@end

NS_ASSUME_NONNULL_END
