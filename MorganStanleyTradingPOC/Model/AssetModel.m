//
//  AssetModel.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "AssetModel.h"

@implementation AssetModel

- (instancetype)initWithDictionary: (NSDictionary*) dict {
    self = [super init];
    if (self) {
        _identifier = dict[@"id"];
        _assetType = dict[@"class"];
        _symbol = dict[@"symbol"];
        _name= dict[@"name"];
    }
    return self;
}

@end
