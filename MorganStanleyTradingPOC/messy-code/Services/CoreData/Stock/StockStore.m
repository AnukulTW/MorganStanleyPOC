#import "StockStore.h"
#import "CoreDataStack.h"
#import "StockItem.h"

@implementation StockStore

+ (instancetype)shared {
    static StockStore *store = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[self alloc] init];
    });
    return store;
}

- (void)saveStocks:(NSArray<NSDictionary *> *)stockDicts ofType:(NSString *)type {
    NSManagedObjectContext *context = [CoreDataStack shared].persistentContainer.viewContext;
    for (NSDictionary *dict in stockDicts) {
        StockItem *stock = [NSEntityDescription insertNewObjectForEntityForName:@"StockItem" inManagedObjectContext:context];
        stock.symbol = dict[@"symbol"];
        stock.price = [dict[@"price"] doubleValue];
        stock.change = [dict[@"change"] doubleValue];
        stock.volume = [dict[@"volume"] integerValue];
        stock.type = type;
    }
    [context save:nil];
}

- (NSArray<StockItem *> *)fetchStocksOfType:(NSString *)type {
    NSManagedObjectContext *context = [CoreDataStack shared].persistentContainer.viewContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"StockItem"];
    request.predicate = [NSPredicate predicateWithFormat:@"type == %@", type];
    return [context executeFetchRequest:request error:nil];
}

- (void)clearStocksOfType:(NSString *)type {
    NSManagedObjectContext *context = [CoreDataStack shared].persistentContainer.viewContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"StockItem"];
    request.predicate = [NSPredicate predicateWithFormat:@"type == %@", type];
    NSArray<StockItem *> *results = [context executeFetchRequest:request error:nil];
    for (StockItem *obj in results) {
        [context deleteObject:obj];
    }
    [context save:nil];
}
@end
