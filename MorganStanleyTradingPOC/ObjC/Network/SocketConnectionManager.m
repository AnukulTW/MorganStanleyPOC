//
//  SocketConnectionManager.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "SocketConnectionManager.h"
#import <SocketRocket/SRWebSocket.h>


@interface SocketConnectionManager()<SRWebSocketDelegate>
@property (strong, nonatomic) SRWebSocket *webSocket;
@property (strong, nonatomic, nonnull) NSMutableDictionary <NSString *, AssetPriceModel*>* livePriceDictionary;
@property (nonatomic, strong) dispatch_queue_t socketQueue;
@property (nonatomic, strong) NSMutableDictionary <NSString*, AssetPriceModel *>*pendingMessages;
@property (assign, nonatomic)BOOL isEnablePrimeAPI;
@end

@implementation SocketConnectionManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _socketQueue = dispatch_queue_create("com.yourapp.socketQueue", DISPATCH_QUEUE_SERIAL);
        _isEnablePrimeAPI = YES;
        NSURL *url = [self createURL];
        self.webSocket = [[SRWebSocket alloc] initWithURL:url];
        self.webSocket.delegate = self;
        self.webSocket.delegateDispatchQueue = _socketQueue;
        _livePriceDictionary = [[NSMutableDictionary alloc]init];
        dispatch_async(_socketQueue, ^{
            [self.webSocket open];
        });

    }
    return self;
}

- (NSString *)assetNameKey {
    return _isEnablePrimeAPI ? @"sym" : @"S";
}

- (NSString *)bidPriceKey {
    return _isEnablePrimeAPI ? @"bid" : @"bp";
}

- (NSString *)askPriceKey {
    return _isEnablePrimeAPI ? @"ask" : @"ap";
}

- (NSURL *)createURL {
    NSString *baseURL = _isEnablePrimeAPI ? @"wss://euc2.primeapi.io" : @"wss://stream.data.alpaca.markets/v2/iex";
    return [NSURL URLWithString: baseURL];
}

- (NSDictionary *)authDictionary {
    if (_isEnablePrimeAPI) {
        return @{
            @"op": @"auth",
            @"key": @"412a1eadfd-aee20f3516-sz2frh"
        };
        
    } else {
        return @{
            @"action": @"auth",
            @"key": @"PKYZ8FLRID2JGVKBLDJA",
            @"secret": @"ECVgORFsR9EunOvZrSBqmSgz9VzPHOJqTc9C2g0H"
        };
    }
}

- (NSDictionary *)livePriceSubcriptionDictionary: (NSArray<NSString *> *)assets {
    if(_isEnablePrimeAPI) {
        return @{
            @"op": @"subscribe",
            @"pairs": assets,
            @"stream": @"fx1s"
        };
    } else {
        return @{
            @"action": @"subscribe",
            @"quotes": assets
        };
    }
}

- (void)sendMessage:(NSString *)message {
    if (self.webSocket.readyState == SR_OPEN) {
        [self.webSocket send:message];
    } else {
        NSLog(@"WebSocket not ready");
    }
}

#pragma mark - SRWebSocketDelegate

- (void)webSocketDidOpen:(SRWebSocket *)webSocket {
    NSLog(@"WebSocket connected");
    [self authenticateWebSocketConnection];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    
    NSData *responseData;
    if([message isKindOfClass:[NSData class]]) {
        responseData = message;
    } else {
        responseData = [message dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSError *error;
    
    id response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    if([response isKindOfClass: [NSDictionary class]]) {
        NSDictionary* responseDict = response;
        NSArray<NSString*> *keys = responseDict.allKeys;

        if(responseDict != NULL && [keys containsObject: @"sym"]) {
            [self parseResponse:responseDict];
        }
    }
}

- (void)parseResponse: (NSDictionary *)responseDict {

    NSArray<NSString*> *keys = responseDict.allKeys;
    NSString *assetNameKey = [self assetNameKey];
    NSString *bidPriceKey = [self bidPriceKey];
    NSString *askPriceKey = [self askPriceKey];
    
    if([keys containsObject:assetNameKey] &&
       [keys containsObject: bidPriceKey] &&
       [keys containsObject: askPriceKey] &&
       responseDict[assetNameKey] != NULL &&
       responseDict[bidPriceKey] != NULL &&
       responseDict[askPriceKey] != NULL
       ) {
        
        NSString *assetName = responseDict[assetNameKey];
        
        if(_livePriceDictionary[assetName] == NULL) {
            
            Float32 currentBidPrice = [responseDict[bidPriceKey] floatValue];
            Float32 currentAskPrice = [responseDict[askPriceKey] floatValue];
            
            NSUInteger bidPriceDirection = 0;
            NSUInteger askPriceDirection = 0;
            
            AssetPriceModel *priceModel = [[AssetPriceModel alloc]initWithQuoteDictionary: @{
                @"bidPrice": @(currentBidPrice),
                @"askPrice": @(currentAskPrice),
                @"bidPriceDirection": @(bidPriceDirection),
                @"askPriceDirection": @(askPriceDirection)
            }];
            
            _livePriceDictionary[assetName] = priceModel;
            [_connectionDelegate didReceivePrice: priceModel forAsset:assetName];
            
        } else {
            
            AssetPriceModel *model = [self updatePriceModel:responseDict];
            _livePriceDictionary[assetName] = model;
            [_connectionDelegate didReceivePrice: model forAsset:assetName];
        }
    }
}

- (AssetPriceModel *)updatePriceModel: (NSDictionary *)responseDict {
    
    @autoreleasepool {
        
        NSString *assetNameKey = [self assetNameKey];
        NSString *bidPriceKey = [self bidPriceKey];
        NSString *askPriceKey = [self askPriceKey];
        
        NSString *assetSymbol = responseDict[assetNameKey];
        AssetPriceModel *previousModel = _livePriceDictionary[assetSymbol];
        
        Float32 previousBidPrice = previousModel.bidPrice.price;
        Float32 previousAskPrice = previousModel.askPrice.price;
        
        Float32 currentBidPrice = [responseDict[bidPriceKey] floatValue];
        Float32 currentAskPrice = [responseDict[askPriceKey] floatValue];
        
        if(currentAskPrice == previousAskPrice && currentBidPrice == previousBidPrice) {
            return previousModel;
        }
        
        NSUInteger bidPriceDirection = currentBidPrice > previousBidPrice ? 1 : 2;
        NSUInteger askPriceDirection = currentAskPrice > previousAskPrice ? 1 : 2;
        
        
        [previousModel updatePriceModel: @{
            @"bidPrice": @(currentBidPrice),
            @"askPrice": @(currentAskPrice),
            @"bidPriceDirection": @(bidPriceDirection),
            @"askPriceDirection": @(askPriceDirection)
        }];
        
        return  previousModel;
    }
}


- (void)updateAssetLastQuote:(NSArray<AssetQuoteModel*> *)assetQuoteArray {
    for(AssetQuoteModel * assetQuote in assetQuoteArray) {
        NSString *assetName = assetQuote.assetName;
        if(_livePriceDictionary[assetName] == NULL) {
           
            NSUInteger bidPriceDirection = 0;
            NSUInteger askPriceDirection = 0;
            
            AssetPriceModel *priceModel = [[AssetPriceModel alloc]initWithQuoteDictionary: @{
                @"bidPrice": @(assetQuote.bidPrice),
                @"askPrice": @(assetQuote.askPrice),
                @"bidPriceDirection": @(bidPriceDirection),
                @"askPriceDirection": @(askPriceDirection)
            }];
            
            _livePriceDictionary[assetName] = priceModel;
        }
    }
}

- (AssetPriceModel *)fetchPrice:(NSString *)assetName {
    NSLog(@"Value %@",_livePriceDictionary[assetName]);
    return  _livePriceDictionary[assetName];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"WebSocket error: %@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"WebSocket closed: %@", reason);
}

- (void)authenticateWebSocketConnection {
    NSDictionary *authPayload = [self authDictionary];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authPayload options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendMessage:jsonString];
   
}

- (void)subscribeAssets:(NSArray<NSString *>*)assets {
    NSDictionary *subscriptionDict = [self livePriceSubcriptionDictionary: assets];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subscriptionDict options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendMessage:jsonString];
}

@end


/*

 AMZN, AAPL,MLGO, INTC,
 
*/
