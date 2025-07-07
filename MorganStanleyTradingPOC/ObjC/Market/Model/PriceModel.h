//
//  PriceModel.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AssetPriceChangeDirection) {
    AssetPriceChangeDirectionNone = 0,
    AssetPriceChangeDirectionUp = 1,
    AssetPriceChangeDirectionDown = 2
};

NS_ASSUME_NONNULL_BEGIN

@interface PriceModel : NSObject
@property(nonatomic, assign) Float32 price;
@property(nonatomic, assign) AssetPriceChangeDirection direction;

- (instancetype)initWithDictionary: (NSDictionary*) dict;

@end

NS_ASSUME_NONNULL_END
