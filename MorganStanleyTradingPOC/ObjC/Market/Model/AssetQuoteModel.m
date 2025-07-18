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
        _assetName = asset;
        _bidPrice = [dict[@"bidPrice"] floatValue];
        _askPrice = [dict[@"askPrice"] floatValue];
    }
    return self;
}

@end
