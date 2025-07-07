//
//  MarketMoverModel.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MarketMoverModel : NSObject
@property(nonatomic, nonnull, strong) NSString *assetName;
@property(nonatomic, assign) Float32 percent_change;
@property(nonatomic, assign) Float32 price;
@property(nonatomic, assign) Float32 change;

- (instancetype)initWithDictionary: (NSDictionary*) dict;
+ (NSArray<MarketMoverModel*> *)initWithArray: (NSArray<NSDictionary*>*) responseArray;


@end

NS_ASSUME_NONNULL_END
