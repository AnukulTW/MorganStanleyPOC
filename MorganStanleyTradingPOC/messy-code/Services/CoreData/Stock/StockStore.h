
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface StockStore : NSObject
+ (instancetype)shared;

- (void)saveStocks:(NSArray<NSDictionary *> *)stockDicts ofType:(NSString *)type;
- (NSArray *)fetchStocksOfType:(NSString *)type;
- (void)clearStocksOfType:(NSString *)type;

@end
