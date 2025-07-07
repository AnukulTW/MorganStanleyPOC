//
//  ActiveStockModel.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ActiveStockModel : NSObject

@property(nonatomic, nonnull, strong) NSString *assetName ;
@property(nonatomic, assign) int64_t tradeCount;
@property(nonatomic, assign) int64_t volume;

- (instancetype)initWithDictionary: (NSDictionary*) dict;
+ (NSArray<ActiveStockModel*> *)initWithArray: (NSArray<NSDictionary*>*) responseArray;

@end

NS_ASSUME_NONNULL_END
