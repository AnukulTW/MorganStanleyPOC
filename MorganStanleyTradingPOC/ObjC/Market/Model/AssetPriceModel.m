//
//  AssetPriceModel.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import "AssetPriceModel.h"

@implementation AssetPriceModel

- (instancetype)initWithQuoteDictionary: (NSDictionary*) dict {
    self = [super init];
    if (self) {
        _bidPrice = [[PriceModel alloc]initWithDictionary: @{
            @"price": dict[@"bidPrice"],
            @"priceDirection": dict[@"bidPriceDirection"]
        }];
        _askPrice = [[PriceModel alloc]initWithDictionary: @{
            @"price": dict[@"askPrice"],
            @"priceDirection": dict[@"askPriceDirection"]
        }];
    }
    return self;
}
@end
