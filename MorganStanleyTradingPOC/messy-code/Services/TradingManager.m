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
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.config.getBaseURL,Constants.marketMoversEndPoint]];
    NSDictionary *queryParams = @{ @"top": @"20" };
    
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
}

- (void)fetchActiveStocks:(void (^)(NSArray<ActiveStockModel*>*  _Nullable, NSError* _Nullable))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", Constants.alpacaBaseURL, Constants.marketMostActiveStocksEndPoint];
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary *queryParams = @{ @"top": @"20",
                                   @"by": @"volume"};
    
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
}
@end
