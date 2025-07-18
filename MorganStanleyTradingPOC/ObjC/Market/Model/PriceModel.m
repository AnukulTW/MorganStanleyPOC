//
//  PriceModel.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import "PriceModel.h"

@implementation PriceModel

- (instancetype)initWithDictionary: (NSDictionary*) dict {
    self = [super init];
    if (self) {
        _price = [dict[@"price"] floatValue];
        _direction = [dict[@"priceDirection"] integerValue];
        _priceType = [dict[@"priceType"] integerValue];
    }
    return self;
}

- (void)updatePriceModel: (NSDictionary*) dict {
    _price = [dict[@"price"] floatValue];
    _direction = [dict[@"priceDirection"] integerValue];
    _priceType = [dict[@"priceType"] integerValue];
}

@end
