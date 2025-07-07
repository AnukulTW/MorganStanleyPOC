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
        _bidPrice = [dict[@"bp"] floatValue];
        _askPrice = [dict[@"ap"] floatValue];
    }
    return self;
}
@end
