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

typedef NS_ENUM(NSInteger, AssetPriceType) {
    AssetPriceTypeBid = 0,
    AssetPriceTypeAsk = 1
};

NS_ASSUME_NONNULL_BEGIN

@interface PriceModel : NSObject
@property(nonatomic, assign) Float32 price;
@property(nonatomic, assign) AssetPriceChangeDirection direction;
@property(nonatomic, assign) AssetPriceType priceType;

- (instancetype)initWithDictionary: (NSDictionary*) dict;
- (void)updatePriceModel: (NSDictionary*) dict;

@end

NS_ASSUME_NONNULL_END
