
#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@interface CoreDataStack : NSObject
@property (readonly, strong) NSPersistentContainer *persistentContainer;
+ (instancetype)shared;
@end
