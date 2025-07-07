//
//  NetworkConnectionManager.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import <Foundation/Foundation.h>
#import "NetworkManaging.h"
NS_ASSUME_NONNULL_BEGIN

typedef void(^NetworkCompletion)(NSData * _Nullable data, NSError * _Nullable error);

@interface NetworkConnectionManager : NSObject<NetworkManaging>

- (instancetype)initWithAPIKey:(NSString *)apiKey
                    apiSecret:(NSString *)apiSecret;

@end

NS_ASSUME_NONNULL_END

