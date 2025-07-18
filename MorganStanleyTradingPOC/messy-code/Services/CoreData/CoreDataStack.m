
#import "CoreDataStack.h"

@implementation CoreDataStack

+ (instancetype)shared {
    static CoreDataStack *stack = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stack = [[self alloc] init];
    });
    return stack;
}

- (instancetype)init {
    if (self = [super init]) {
        _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"TradeModel"];
        [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *desc, NSError *error) {}];
    }
    return self;
}
@end
