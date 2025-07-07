//
//  MarketMoverModel.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import "MarketMoverModel.h"

@implementation MarketMoverModel

- (instancetype)initWithDictionary: (NSDictionary*) dict {
    self = [super init];
    if (self) {
        _assetName = dict[@"symbol"];
        _change = [dict[@"change"] floatValue];
        _percent_change = [dict[@"percent_change"] floatValue];
        _price = [dict[@"price"] floatValue];
    }
    return self;
}

+ (NSArray<MarketMoverModel*> *)initWithArray: (NSArray<NSDictionary*>*) responseArray {
    NSMutableArray *marketMoverArray = [[NSMutableArray alloc]initWithCapacity: [responseArray count]];
    for (NSDictionary *response in responseArray) {
        MarketMoverModel *model = [[MarketMoverModel alloc]initWithDictionary: response];
        if(model != NULL) {
            [marketMoverArray addObject:model];
        }
    }
    
    return marketMoverArray;
}



@end
