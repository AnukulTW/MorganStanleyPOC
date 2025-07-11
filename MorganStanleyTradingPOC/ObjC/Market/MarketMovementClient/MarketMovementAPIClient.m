//
//  MarketMovementAPIClient.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import "MarketMovementAPIClient.h"
#import "NetworkManaging.h"
#import "MorganStanleyTradingPOC-Swift.h"

@interface MarketMovementAPIClient()
@property (nonatomic, strong) id<NetworkManaging> networkManager;
@end

@implementation MarketMovementAPIClient

- (instancetype)initWithNetworkManager:(id<NetworkManaging>)networkManager {
    self = [super init];
    if (self) {
        _networkManager = networkManager;
    }
    return self;
}


- (void)fetchMarketTopMovers:(void (^)(NSMutableDictionary<NSString* ,NSArray<MarketMoverModel*>* >* _Nullable , NSError* _Nullable))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", Constants.alpacaBaseURL, Constants.marketMoversEndPoint];
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary *queryParams = @{ @"top": @"20" };
    
    [self.networkManager sendRequestWithURL:url
                                     method:@"GET"
                                queryParams:queryParams
                                    headers:nil
                                       body:nil
                                 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        [self parseMarketTopMovers:data completion:completion];
    }];
}

- (void)parseMarketTopMovers:(nullable NSData *)data completion:(void (^)(NSMutableDictionary<NSString* ,NSArray<MarketMoverModel*>* >* _Nullable , NSError* _Nullable))completion {
    NSError *error;
    NSMutableDictionary *marketMovers = [[NSMutableDictionary alloc]init];
    
    if(data != NULL) {
        NSError *decodingError;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData: data options: 0 error: &decodingError];
        
        if(responseDictionary[@"gainers"] != NULL) {
            NSArray *topGainResponse = responseDictionary[@"gainers"];
            NSArray *topGainers = [MarketMoverModel initWithArray: topGainResponse];
            marketMovers[@"gainers"] = topGainers;
        }
        
        if(responseDictionary[@"losers"] != NULL) {
            NSArray *topGainResponse = responseDictionary[@"losers"];
            NSArray *topLosers = [MarketMoverModel initWithArray: topGainResponse];
            marketMovers[@"losers"] = topLosers;
        }
    }
    
    completion(marketMovers, error);
}

- (void)fetchActiveStocks:(void (^)(NSArray<ActiveStockModel*>*  _Nullable, NSError* _Nullable))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", Constants.alpacaBaseURL, Constants.marketMostActiveStocksEndPoint];
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary *queryParams = @{ @"top": @"20",
                                   @"by": @"volume"};
    
    [self.networkManager sendRequestWithURL:url
                                     method:@"GET"
                                queryParams:queryParams
                                    headers:nil
                                       body:nil
                                 completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        [self parseActiveMovers:data completion:completion];
    }];
}

- (void)parseActiveMovers:(nullable NSData*)data completion:(void (^)(NSArray<ActiveStockModel*>*  _Nullable, NSError* _Nullable))completion {
    NSArray *mostActiveStocks = [[NSArray alloc]init];
    if(data != NULL) {
        NSError *decodingError;
        NSDictionary *responseDictionary = [NSJSONSerialization JSONObjectWithData: data options: 0 error: &decodingError];
        
        if(responseDictionary[@"most_actives"] != NULL) {
            NSArray *responseArray = responseDictionary[@"most_actives"];
            mostActiveStocks = [ActiveStockModel initWithArray:responseArray];
        }
    }
    
    completion(mostActiveStocks, nil);
}

@end
