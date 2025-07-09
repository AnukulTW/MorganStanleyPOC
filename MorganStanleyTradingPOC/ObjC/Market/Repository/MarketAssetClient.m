//
//  MarketAssetClient.m
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 04/07/25.
//

#import "MarketAssetClient.h"
#import <Foundation/Foundation.h>
#import "AssetModel.h"
#import "AssetQuoteModel.h"
#import "MorganStanleyTradingPOC-Swift.h"
#import "NetworkManaging.h"
#import "AssetQuoteModel.h"

@interface MarketAssetClient ()
@property (nonatomic, strong) id<NetworkManaging> networkManager;
@end

@implementation MarketAssetClient

- (instancetype)initWithNetworkManager:(id<NetworkManaging>)networkManager {
    self = [super init];
    if (self) {
        _networkManager = networkManager;
    }
    return self;
}

- (void)fetchMarketAssetWithCompletion:(void (^)(NSArray<AssetQuoteModel *> * _Nullable result, NSArray<NSString *> * _Nullable list, NSError * _Nullable error))completion {
    [self fetchMarketData:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error || !data) {
            completion(nil,nil, error);
            return;
        }

        [self parseMarketData:data completion:completion];
    }];
}

- (void)fetchLastQuoteForAsset:(nonnull NSArray<NSString *> *)symbols
                    completion:(nonnull void (^)(NSArray<AssetQuoteModel *> * _Nullable, NSError * _Nullable))completion {

    [self fetchLastQuotes:symbols completion:^(NSData * _Nullable data, NSError * _Nullable error) {
        if (error || !data) {
            completion(nil, error);
            return;
        }
        [self parseLastQuotesData:symbols data:data completion:completion];
    }];
}

#pragma mark - Private

- (void)fetchMarketData:(void (^)(NSData * _Nullable data, NSError * _Nullable error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", Constants.paperApiBaseURL, Constants.marketAsset];
    NSURL *url = [NSURL URLWithString:urlString];
    NSDictionary *queryParams = @{ @"status": @"active" };

    [self.networkManager sendRequestWithURL:url
                                     method:@"GET"
                                queryParams:queryParams
                                    headers:nil
                                       body:nil
                                 completion:completion];
}

- (void)parseMarketData:(nullable NSData *)data
       completion:(void (^)(NSArray<AssetQuoteModel *> * _Nullable result, NSArray<NSString *> * _Nullable list, NSError * _Nullable error))completion {
    NSError *error;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        completion(nil,nil, error);
        return;
    }
    
    NSMutableArray *assetArray = [[NSMutableArray alloc]init];
    NSMutableArray<NSString *> *assetList = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in json) {
        AssetModel *model = [[AssetModel alloc]initWithDictionary: dict];
        if(model != NULL && model.tradable) {
            [assetArray addObject:model];
            [assetList addObject: model.symbol];
        }
    }

    completion(assetArray,assetList, nil);
}

#pragma mark - Fetch Quotes (Private Methods)

- (void)fetchLastQuotes:(nonnull NSArray<NSString *> *)symbols completion: (void (^)(NSData * _Nullable data, NSError * _Nullable error))completion {
    NSString *urlString = [NSString stringWithFormat:@"%@%@", Constants.baseURL, Constants.latestQuotes];
    NSURL *url = [NSURL URLWithString:urlString];
    NSString *commaSeparateQuotes = [symbols componentsJoinedByString: @","];
    NSString *encodedString = [commaSeparateQuotes stringByAddingPercentEncodingWithAllowedCharacters: [NSCharacterSet URLQueryAllowedCharacterSet]];
    
    NSString *parameterString = Constants.isEnablePrimeAPI ? @"pairs" : @"symbols";
    NSDictionary *queryParams = @{ parameterString: encodedString };

    [self.networkManager sendRequestWithURL:url
                                     method:@"GET"
                                queryParams:queryParams
                                    headers:nil
                                       body:nil
                                 completion:completion];
}


- (void)parseLastQuotesData:(nonnull NSArray<NSString *> *)symbols
                       data:(nullable NSData *)data
                 completion:(void (^)(NSArray<AssetQuoteModel *> * _Nullable result,
                                      NSError * _Nullable error))completion{
    NSError *decodingError;
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&decodingError];
    if (decodingError || ![json isKindOfClass:[NSDictionary class]]) {
        completion(nil, decodingError);
        return;
    }
    
    NSDictionary *quotesDict = json[@"quotes"];
    NSMutableArray *assetQuoteArray = [[NSMutableArray alloc]initWithCapacity: [symbols count]];
    if(quotesDict != NULL) {
        [quotesDict enumerateKeysAndObjectsUsingBlock:^(NSString *assetName, NSDictionary *quoteDict, BOOL *stop) {
            
            Float32 bidPrice = Constants.isEnablePrimeAPI ? [quoteDict[@"bid"] floatValue] : [quoteDict[@"bp"] floatValue];
            Float32 askPrice = Constants.isEnablePrimeAPI ? [quoteDict[@"ask"] floatValue] : [quoteDict[@"ap"] floatValue];
            
            NSDictionary *dict = @{
                @"bidPrice": @(bidPrice),
                @"askPrice": @(askPrice)
            };
            
            AssetQuoteModel *model = [[AssetQuoteModel alloc]initWithQuoteDictionary:dict
                                                                            forAsset:assetName];
            if(model != NULL) {
                [assetQuoteArray addObject: model];
            }
        }];
    }
    completion(assetQuoteArray, nil);
}

@end
