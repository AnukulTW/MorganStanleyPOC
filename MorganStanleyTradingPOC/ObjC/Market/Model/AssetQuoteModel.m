//
//  AssetQuoteModel.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import "AssetQuoteModel.h"
#import "MorganStanleyTradingPOC-Swift.h"

@implementation AssetQuoteModel

- (instancetype)initWithQuoteDictionary: (NSDictionary*) dict
                               forAsset: (NSString *)asset {
    self = [super init];
    if (self) {
        
        NSString *bidPriceKey = [Constants bidPriceKey];
        NSString *askPriceKey = [Constants askPriceKey];

        _assetName = asset;
        _bidPrice = [dict[bidPriceKey] floatValue];
        _askPrice = [dict[askPriceKey] floatValue];
    }
    return self;
}

@end
