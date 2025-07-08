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
@property (nonatomic, strong) NSTimer *throttleTimer;
@property (nonatomic, strong) NSMutableDictionary <NSString*, AssetPriceModel *>*pendingMessages;


@end

@implementation SocketConnectionManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _socketQueue = dispatch_queue_create("com.yourapp.socketQueue", DISPATCH_QUEUE_SERIAL);
        //NSURL *url = [NSURL URLWithString:@"wss://stream.data.alpaca.markets/v2/iex"];
        
        NSURL *url = [NSURL URLWithString:@"wss://euc2.primeapi.io"];
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
    
    NSString *assetSymbol = responseDict[@"sym"];
    NSArray<NSString*> *keys = responseDict.allKeys;
    
    if(_livePriceDictionary[assetSymbol] == NULL) {
        if([keys containsObject: @"sym"] &&
           [keys containsObject: @"bid"] &&
           [keys containsObject: @"ask"] &&
           responseDict[@"sym"] != NULL &&
           responseDict[@"bid"] != NULL &&
           responseDict[@"ask"] != NULL
           ) {
            NSString *assetSymbol = responseDict[@"sym"];
            
            Float32 currentBidPrice = [responseDict[@"bid"] floatValue];
            Float32 currentAskPrice = [responseDict[@"ask"] floatValue];
            
            NSUInteger bidPriceDirection = 0;
            NSUInteger askPriceDirection = 0;
            
            AssetPriceModel *priceModel = [[AssetPriceModel alloc]initWithQuoteDictionary: @{
                @"bidPrice": @(currentBidPrice),
                @"askPrice": @(currentAskPrice),
                @"bidPriceDirection": @(bidPriceDirection),
                @"askPriceDirection": @(askPriceDirection)
            }];
            
            
            _livePriceDictionary[assetSymbol] = priceModel;
            [_connectionDelegate didReceivePrice: priceModel forAsset:assetSymbol];
        }
    } else {
            
            
            if([keys containsObject: @"sym"] &&
               [keys containsObject: @"bid"] &&
               [keys containsObject: @"ask"] &&
               responseDict[@"sym"] != NULL &&
               responseDict[@"bid"] != NULL &&
               responseDict[@"ask"] != NULL
               ) {
                
                
                AssetPriceModel *model = [self updatePriceModel:responseDict];
                _livePriceDictionary[assetSymbol] = model;
                [_connectionDelegate didReceivePrice: model forAsset:assetSymbol];
            }
            
        }
}

- (AssetPriceModel *)updatePriceModel: (NSDictionary *)responseDict {
    
    @autoreleasepool {
        
        NSString *assetSymbol = responseDict[@"sym"];
        AssetPriceModel *previousModel = _livePriceDictionary[assetSymbol];
        
        Float32 previousBidPrice = previousModel.bidPrice.price;
        Float32 previousAskPrice = previousModel.askPrice.price;
        
        Float32 currentBidPrice = [responseDict[@"bid"] floatValue];
        Float32 currentAskPrice = [responseDict[@"ask"] floatValue];
        
        if(currentAskPrice == previousAskPrice && currentBidPrice == previousBidPrice) {
            NSLog(@"Return printed");
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
//    NSDictionary *authPayload = @{@"action": @"auth", @"key": @"PKYZ8FLRID2JGVKBLDJA", @"secret": @"ECVgORFsR9EunOvZrSBqmSgz9VzPHOJqTc9C2g0H"};
    NSDictionary *authPayload = @{@"op": @"auth", @"key": @"412a1eadfd-aee20f3516-sz2frh"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authPayload options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendMessage:jsonString];
   
}

- (void)subscribeAssets:(NSArray<NSString *>*)assets {
    // NSDictionary *authPayload = @{@"action": @"subscribe", @"quotes": @[@"AMZN", @"AAPL",@"MLGO", @"INTC"]};
    //NSDictionary *authPayload = @{@"action": @"subscribe", @"quotes": @[@"AVAX/USD", @"BTC/USD"]};
    NSDictionary *authPayload = @{@"op": @"subscribe", @"pairs": assets, @"stream": @"fx"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authPayload options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendMessage:jsonString];
}


- (void)startThrottleTimer {
    if (!self.throttleTimer) {
        self.throttleTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                               target:self
                                                             selector:@selector(fireThrottledUpdate)
                                                             userInfo:nil
                                                              repeats:NO];
    }
}

- (void)fireThrottledUpdate {
    NSArray *batch = nil;
    @synchronized (self.pendingMessages) {
        batch = [self.pendingMessages copy];
        [self.pendingMessages removeAllObjects];
    }
    
    if (batch.count > 0) {
        //[_connectionDelegate didReceivePrice:priceModel forAsset:assetSymbol];
        [_connectionDelegate didReceivePrice: batch];
    }
    
    [self.throttleTimer invalidate];
    self.throttleTimer = nil;
}

@end


/*

 AMZN, AAPL,MLGO, INTC,
 
*/
