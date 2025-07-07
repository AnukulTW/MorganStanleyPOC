//
//  MarketMovementAPIClient.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import "MarketMovementAPIClient.h"

@interface MarketMovementAPIClient()
@property (strong, nonatomic) NSURLSession *urlSession;
@end

@implementation MarketMovementAPIClient

- (instancetype)init {
    self = [super init];
    if (self) {
        _urlSession = [NSURLSession sharedSession];
    }
    return self;
}


- (void)fetchTopMarketMovers:(void (^)(NSMutableDictionary<NSString* ,NSArray<MarketMoverModel*>* >* _Nullable , NSError* _Nullable))completion {
    NSURL *baseURL = [[NSURL alloc]initWithString: @"https://data.alpaca.markets/v1beta1/screener/stocks/movers"];
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:NO];
    NSURLQueryItem *topMoversQueryItem = [NSURLQueryItem queryItemWithName:@"top"
                                                                     value: @"20"];
    components.queryItems = @[topMoversQueryItem];
    NSURL *finalURL = components.URL;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"PKYZ8FLRID2JGVKBLDJA" forHTTPHeaderField:@"APCA-API-KEY-ID"];
    [request setValue:@"ECVgORFsR9EunOvZrSBqmSgz9VzPHOJqTc9C2g0H" forHTTPHeaderField:@"APCA-API-SECRET-KEY"];
    
    NSURLSessionDataTask *task = [_urlSession dataTaskWithRequest: request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
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
    }];
    
    [task resume];
}

- (void)fetchActiveStocks:(void (^)(NSArray<ActiveStockModel*>*  _Nullable, NSError* _Nullable))completion {
    NSURL *baseURL = [[NSURL alloc]initWithString: @"https://data.alpaca.markets/v1beta1/screener/stocks/most-actives"];
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:NO];
    NSURLQueryItem *responseCountQueryItem = [NSURLQueryItem queryItemWithName:@"top"
                                                                         value: @"20"];
    NSURLQueryItem *responseByQueryItem = [NSURLQueryItem queryItemWithName:@"by"
                                                                         value: @"volume"];
    components.queryItems = @[responseCountQueryItem, responseByQueryItem];
    NSURL *finalURL = components.URL;
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"PKYZ8FLRID2JGVKBLDJA" forHTTPHeaderField:@"APCA-API-KEY-ID"];
    [request setValue:@"ECVgORFsR9EunOvZrSBqmSgz9VzPHOJqTc9C2g0H" forHTTPHeaderField:@"APCA-API-SECRET-KEY"];
    
    NSURLSessionDataTask *task = [_urlSession dataTaskWithRequest: request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        
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
        
    }];
    
    [task resume];
}

@end
