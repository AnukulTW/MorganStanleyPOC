//
//  StockItem 2.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 18/07/25.
//


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface StockItem : NSManagedObject
+ (NSFetchRequest<StockItem *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *symbol;
@property (nonatomic) double price;
@property (nonatomic) double change;
@property (nonatomic) int64_t volume;
@property (nullable, nonatomic, copy) NSString *type;
@end

NS_ASSUME_NONNULL_END

