//
//  NewsItem+CoreDataProperties.h
//  
//  Created by Shrey Shrivastava on 18/07/25.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NewsItem;

NS_ASSUME_NONNULL_BEGIN

@interface NewsItem : NSManagedObject

@property (nullable, nonatomic, copy) NSString *headline;
@property (nullable, nonatomic, copy) NSString *summary;
@property (nullable, nonatomic, copy) NSString *source;
@property (nullable, nonatomic, copy) NSString *link;
@property (nullable, nonatomic, strong) NSDate *publishedAt;
@property (nullable, nonatomic, copy) NSString *imgURL;

@end

NS_ASSUME_NONNULL_END
