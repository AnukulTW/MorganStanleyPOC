#import "NewsStore.h"
#import "CoreDataStack.h"
#import "NewsItem.h"

@implementation NewsStore

+ (instancetype)shared {
    static NewsStore *store = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[self alloc] init];
    });
    return store;
}

- (void)saveNews:(NSArray<NSDictionary *> *)newsDicts {
    NSManagedObjectContext *context = [CoreDataStack shared].persistentContainer.viewContext;
    for (NSDictionary *dict in newsDicts) {
        NewsItem *news = [NSEntityDescription insertNewObjectForEntityForName:@"NewsItem" inManagedObjectContext:context];
        news.headline = dict[@"headline"];
        news.summary = dict[@"summary"];
        news.source = dict[@"source"];
        news.link = dict[@"url"];
        news.publishedAt = [NSDate dateWithTimeIntervalSince1970:[dict[@"created_at"] doubleValue]];
    }
    [context save:nil];
}

- (NSArray<NewsItem *> *)fetchNews {
    NSManagedObjectContext *context = [CoreDataStack shared].persistentContainer.viewContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NewsItem"];
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"publishedAt" ascending:NO];
    request.sortDescriptors = @[sort];
    return [context executeFetchRequest:request error:nil];
}

- (void)clearNews {
    NSManagedObjectContext *context = [CoreDataStack shared].persistentContainer.viewContext;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"NewsItem"];
    NSArray<NewsItem *> *results = [context executeFetchRequest:request error:nil];
    for (NewsItem *obj in results) {
        [context deleteObject:obj];
    }
    [context save:nil];
}
@end
