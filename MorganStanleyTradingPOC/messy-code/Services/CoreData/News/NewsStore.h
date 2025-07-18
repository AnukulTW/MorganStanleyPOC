
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NewsStore : NSObject
+ (instancetype)shared;

- (void)saveNews:(NSArray<NSDictionary *> *)newsDicts;
- (NSArray *)fetchNews;
- (void)clearNews;

@end
