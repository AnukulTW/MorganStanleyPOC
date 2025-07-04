
//
//  Quotes.m
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//
#import <Foundation/Foundation.h>
#import "NetworkManaging.h"
@class AssetQuoteModel;

NS_ASSUME_NONNULL_BEGIN

@interface QuotesClient : NSObject
- (instancetype)initWithNetworkManager:(id<NetworkManaging>)networkManager;

@end
