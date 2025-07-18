//
//  TradingManager.m
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 17/07/25.
//

@import Foundation;
#import "TradingManager.h"
#import "AppDelegate.h"
#import "Config.h"
#import "MarketMoverModel.h"
#import "ActiveStockModel.h"
#import "MorganStanleyTradingPOC-Swift.h"
@import Firebase;
#import "NetworkClient.h"
//#import "FirebaseRemoteConfig.h"
#import "NewsStore.h"
#import "StockStore.h"

@implementation TradingManager {
    NSMutableArray *_orders;
    AppDelegate *_appDelegate;
}

+ (instancetype)sharedInstance {
    static TradingManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[TradingManager alloc] init];
    });
    return instance;
}

-(void)fetchRemoteConfigs{
        _appDelegate = (AppDelegate*)(UIApplication.sharedApplication.delegate);
    [self->_appDelegate.remoteConfig fetchWithCompletionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (status == FIRRemoteConfigFetchStatusSuccess) {
            NSLog(@"Config fetched successfully!");
            // Once fetched, activate them to make them live in your app
            [self->_appDelegate.remoteConfig activateWithCompletion:^(BOOL changed, NSError * _Nullable error) {
                if (changed) {
                    NSLog(@"Remote Config values activated!");
                    self.config.baseURL = [[self->_appDelegate.remoteConfig configValueForKey:@"BaseURL"] stringValue];
                    self.config.apiKey = [[self->_appDelegate.remoteConfig configValueForKey:@"APIKey"] stringValue];
                    self.config.apiSecret = [[self->_appDelegate.remoteConfig configValueForKey:@"APISecret"] stringValue];
                } else {
                    NSLog(@"Remote Config values are already current.");
                }
                // Now that values are activated, you can load your ad unit or update UI
                // For example, if you're optimizing AdMob ad frequency:
                // [self loadAdUnit];
            }];
        } else {
            NSLog(@"Config not fetched. Error: %@", error.localizedDescription);
            // Even if fetch fails, the last activated values are still available
            // [self loadAdUnit]; // You might still proceed with default/cached values
        }
    }];

}

- (void)fetchMarketTopMovers:(void (^)(NSMutableDictionary<NSString* ,NSArray<MarketMoverModel*>* >* _Nullable , NSError* _Nullable))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", self.config.getBaseURL, Constants.marketMoversEndPoint];
    NSDictionary *queryParams = @{ @"top": @"20" };
    NSDictionary *headers = @{
        @"APCA-API-KEY-ID": self.config.apiKey ?: @"",
        @"APCA-API-SECRET-KEY": self.config.apiSecret ?: @"",
        @"Content-Type": @"application/json"
    };
    [[NetworkClient sharedInstance] GET:urlString parameters:queryParams headers:headers completion:^(id  _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSMutableDictionary *marketMovers = [[NSMutableDictionary alloc]init];
        NSInteger responseStatusCode = [(NSHTTPURLResponse *)response statusCode];
        [FIRAnalytics logEventWithName:@"fetchMarketTopMovers"
                            parameters:@{
                                @"api_endpoint": Constants.marketMoversEndPoint,
                                @"status_code": @(responseStatusCode),
                                @"error_message": error ? error.description : @"N/A"
                            }];
        if(responseObject != NULL) {
            if(responseObject[@"gainers"] != NULL) {
                NSArray *topGainResponse = responseObject[@"gainers"];
                NSArray *topGainers = [MarketMoverModel initWithArray: topGainResponse];
                marketMovers[@"gainers"] = topGainers;
                // Save gainers to Core Data
                [[StockStore shared] saveStocks:topGainResponse ofType:@"gainers"];
            }
            if(responseObject[@"losers"] != NULL) {
                NSArray *topGainResponse = responseObject[@"losers"];
                NSArray *topLosers = [MarketMoverModel initWithArray: topGainResponse];
                marketMovers[@"losers"] = topLosers;
                // Save losers to Core Data
                [[StockStore shared] saveStocks:topGainResponse ofType:@"losers"];
            }
        }
        completion(marketMovers, error);
    }];
    /*
    // Backward compatible NSURLSession code
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:self.config.apiKey forKey:@"APCA-API-KEY-ID"];
        [request setValue:self.config.apiSecret forHTTPHeaderField:@"APCA-API-SECRET-KEY"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSData *body = [NSJSONSerialization dataWithJSONObject:queryParams options:0 error:nil];
        [request setHTTPBody:body];
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                        completionHandler:^(NSData * _Nullable data,
                                                                            NSURLResponse * _Nullable response,
                                                                            NSError * _Nullable error) {
            NSMutableDictionary *marketMovers = [[NSMutableDictionary alloc]init];
            NSInteger responseStatusCode = [(NSHTTPURLResponse *)response statusCode];
            [FIRAnalytics logEventWithName:@"fetchMarketTopMovers"
                                        parameters:@{
                                            @"api_endpoint": Constants.marketMoversEndPoint,
                                            @"status_code": @(responseStatusCode), // Convert NSInteger to NSNumber
                                            @"error_message": error.description.length > 0 ? error.description : @"N/A" // Log error if present
                                        }];
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
    });
    */
}

- (void)getMostActiveStocksWithCompletion:(void (^)(NSArray *stocks))completion {
    NSString *url = [NSString stringWithFormat:@"%@%@", self.config.getBaseURL, Constants.marketMostActiveStocksEndPoint];
    NSDictionary *params = @{@"by": @"volume", @"top": @"10"};
    NSDictionary *headers = @{
        @"APCA-API-KEY-ID": self.config.apiKey,
        @"APCA-API-SECRET-KEY": self.config.apiSecret,
        @"accept": @"application/json"
    };
    
    [[NetworkClient sharedInstance] GET:url parameters:params headers:headers completion:^(id responseObject, NSURLResponse *response, NSError *error) {
        if (!error && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *results = responseObject[@"most_actives"];
            // Save most active stocks to Core Data
            [[StockStore shared] saveStocks:results ofType:@"most_active"];
            if (completion) {
                completion(results);
            }
        } else {
            completion(@[]);
        }
    }];
}

- (void)getTopMoversWithCompletion:(void (^)(NSArray *movers))completion {
    //NSString *url = @"https://data.alpaca.markets/v1beta1/screener/stocks/movers";
    NSString *url = [NSString stringWithFormat:@"%@%@", self.config.getBaseURL, Constants.marketMoversEndPoint];
    NSDictionary *params = @{@"top": @"10"};
    NSDictionary *headers = @{
        @"APCA-API-KEY-ID": self.config.apiKey,
        @"APCA-API-SECRET-KEY": self.config.apiSecret,
        @"accept": @"application/json"
    };
    
    [[NetworkClient sharedInstance] GET:url parameters:params headers:headers completion:^(id responseObject, NSURLResponse *response, NSError *error) {
        if (!error && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *results = responseObject[@"movers"];
            // Save top movers to Core Data
            [[StockStore shared] saveStocks:results ofType:@"movers"];
            if (completion) {
                completion(results);
            }
        } else {
            completion(@[]);
        }
    }];
}

- (void)getLatestNewsWithCompletion:(void (^)(NSArray *news))completion {
//    NSString *url = @"https://data.alpaca.markets/v1beta1/news";
    NSString *url = [NSString stringWithFormat:@"%@%@", self.config.getBaseURL, Constants.newsEndPoint];
    NSDictionary *params = @{@"sort": @"desc"};
    NSDictionary *headers = @{
        @"APCA-API-KEY-ID": self.config.apiKey,
        @"APCA-API-SECRET-KEY": self.config.apiSecret,
        @"accept": @"application/json"
    };

    [[NetworkClient sharedInstance] GET:url parameters:params headers:headers completion:^(id responseObject, NSURLResponse *response, NSError *error) {
        if (!error && [responseObject isKindOfClass:[NSDictionary class]]) {
            NSArray *results = responseObject[@"news"];
            // Save news to Core Data
            [[NewsStore shared] saveNews:results];
            if (completion) {
                completion(results);
            }
        } else {
            completion(@[]);
        }
    }];
}


- (void)fetchActiveStocks:(void (^)(NSArray<ActiveStockModel*>*  _Nullable, NSError* _Nullable))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", Constants.alpacaBaseURL, Constants.marketMostActiveStocksEndPoint];
    NSDictionary *queryParams = @{ @"top": @"20", @"by": @"volume" };
    NSDictionary *headers = @{
        @"APCA-API-KEY-ID": self.config.apiKey ?: @"",
        @"APCA-API-SECRET-KEY": self.config.apiSecret ?: @"",
        @"Content-Type": @"application/json"
    };
    [[NetworkClient sharedInstance] GET:urlString parameters:queryParams headers:headers completion:^(id  _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSArray *mostActiveStocks = [[NSArray alloc]init];
        NSInteger responseStatusCode = [(NSHTTPURLResponse *)response statusCode];
        [FIRAnalytics logEventWithName:@"fetchActiveStocks"
                            parameters:@{
                                @"api_endpoint": Constants.marketMoversEndPoint,
                                @"status_code": @(responseStatusCode),
                                @"error_message": error ? error.description : @"N/A"
                            }];
        if(responseObject != NULL) {
            if(responseObject[@"most_actives"] != NULL) {
                NSArray *responseArray = responseObject[@"most_actives"];
                mostActiveStocks = [ActiveStockModel initWithArray:responseArray];
                // Save most active stocks to Core Data
                [[StockStore shared] saveStocks:responseArray ofType:@"most_active"];
            }
        }
        completion(mostActiveStocks, error);
    }];
    /*
    // Backward compatible NSURLSession code
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:self.config.apiKey forKey:@"APCA-API-KEY-ID"];
        [request setValue:self.config.apiSecret forHTTPHeaderField:@"APCA-API-SECRET-KEY"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        NSData *body = [NSJSONSerialization dataWithJSONObject:queryParams options:0 error:nil];
        [request setHTTPBody:body];
        
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                        completionHandler:^(NSData * _Nullable data,
                                                                            NSURLResponse * _Nullable response,
                                                                            NSError * _Nullable error) {
            NSArray *mostActiveStocks = [[NSArray alloc]init];
            NSInteger responseStatusCode = [(NSHTTPURLResponse *)response statusCode];
            [FIRAnalytics logEventWithName:@"fetchActiveStocks"
                                        parameters:@{
                                            @"api_endpoint": Constants.marketMoversEndPoint,
                                            @"status_code": @(responseStatusCode), // Convert NSInteger to NSNumber
                                            @"error_message": error.description.length > 0 ? error.description : @"N/A" // Log error if present
                                        }];
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
    });
    */
}
@end
