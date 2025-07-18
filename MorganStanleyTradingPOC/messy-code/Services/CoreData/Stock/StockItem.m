//
//  StockItem.m
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 18/07/25.
//


#import "StockItem.h"

@implementation StockItem

+ (NSFetchRequest<StockItem *> *)fetchRequest {
    return [NSFetchRequest fetchRequestWithEntityName:@"StockItem"];
}

@dynamic symbol;
@dynamic price;
@dynamic change;
@dynamic volume;
@dynamic type;

@end
