//
//  NetworkConnectionManager.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NetworkConnectionManager : NSObject
- (void)fetchData:(void (^)(NSData* _Nullable , NSError* _Nullable))completion;
- (void)fetchLastQuoteForAsset: (NSArray<NSString *> *)assets
                    completion: (void (^)(NSData* _Nullable , NSError* _Nullable))completion;
@end

NS_ASSUME_NONNULL_END
