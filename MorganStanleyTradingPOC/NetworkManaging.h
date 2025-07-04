//
//  NetworkManaging.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol NetworkManaging <NSObject>

- (void)sendRequestWithURL:(NSURL *)url
                    method:(NSString *)httpMethod
               queryParams:(nullable NSDictionary<NSString *, NSString *> *)queryParams
                   headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                      body:(nullable NSData *)body
                completion:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion;

@end

NS_ASSUME_NONNULL_END
