//
//  SocketConnectionDefaults.m
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 08/07/25.
//
#import <Foundation/Foundation.h>
#import "SocketConnectionDefaults.h"

@implementation SocketConnectionDefaults
- (nonnull NSString *)askPriceKey {
    return _isEnablePrimeAPI ? @"ask" : @"ap";
}

- (nonnull NSString *)assetNameKey {
    return _isEnablePrimeAPI ? @"sym" : @"S";
}

- (nonnull NSString *)bidPriceKey {
    return _isEnablePrimeAPI ? @"bid" : @"bp";
}
@end
