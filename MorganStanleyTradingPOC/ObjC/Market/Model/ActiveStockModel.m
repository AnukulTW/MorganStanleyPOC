//
//  ActiveStockModel.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import "ActiveStockModel.h"

@implementation ActiveStockModel


- (instancetype)initWithDictionary: (NSDictionary*) dict {
    self = [super init];
    if (self) {
        _assetName = dict[@"symbol"];
        _tradeCount = [dict[@"trade_count"] intValue];
        _volume = [dict[@"volume"] intValue];
    }
    return self;
}

+ (NSArray<ActiveStockModel*> *)initWithArray: (NSArray<NSDictionary*>*) responseArray {
    NSMutableArray *activeStockArray = [[NSMutableArray alloc]initWithCapacity: [responseArray count]];
    for (NSDictionary *response in responseArray) {
        ActiveStockModel *model = [[ActiveStockModel alloc]initWithDictionary: response];
        if(model != NULL) {
            [activeStockArray addObject:model];
        }
    }
    
    return activeStockArray;
}


@end
