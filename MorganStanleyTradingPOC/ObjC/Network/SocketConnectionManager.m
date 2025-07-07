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
@end

@implementation SocketConnectionManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:@"wss://stream.data.alpaca.markets/v2/iex"];
        self.webSocket = [[SRWebSocket alloc] initWithURL:url];
        self.webSocket.delegate = self;
        _livePriceDictionary = [[NSMutableDictionary alloc]init];
        [self.webSocket open];
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
    NSArray<NSDictionary*> *responseArray = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    NSDictionary* responseDict = responseArray.lastObject;
    if(responseDict != NULL) {
        NSArray<NSString*> *keys = responseDict.allKeys;
        if([keys containsObject: @"S"] &&
           [keys containsObject: @"bp"] &&
           [keys containsObject: @"ap"] &&
           responseDict[@"S"] != NULL &&
           responseDict[@"bp"] != NULL &&
           responseDict[@"ap"] != NULL
          ) {
            
            NSLog(@"Response Dict %@", responseDict);
            NSString *assetSymbol = responseDict[@"S"];
            NSString *bidPrice = [responseDict[@"bp"] stringValue];
            NSString *askPrice = [responseDict[@"ap"] stringValue];
            
            AssetPriceModel *priceModel = [[AssetPriceModel alloc]initWithQuoteDictionary: @{
                @"bp": bidPrice,
                @"ap": askPrice
            }];
            
            _livePriceDictionary[assetSymbol] = priceModel;
            
            [_connectionDelegate didReceivePrice:priceModel forAsset:assetSymbol];
        }
    }
}

- (void)updateAssetLastQuote:(NSArray<AssetQuoteModel*> *)assetQuoteArray {
    for(AssetQuoteModel * assetQuote in assetQuoteArray) {
        NSString *assetName = assetQuote.assetName;
        if(_livePriceDictionary[assetName] == NULL) {
            NSString *askPrice = [NSString stringWithFormat:@"%.2f", assetQuote.askPrice];
            NSString *bidPrice = [NSString stringWithFormat:@"%.2f", assetQuote.bidPrice];

            _livePriceDictionary[assetName] = [[AssetPriceModel alloc]initWithQuoteDictionary: @{
                @"bp": bidPrice,
                @"ap": askPrice
            }];
        }
    }
}

- (AssetPriceModel *)fetchPrice:(NSString *)assetName {
    return  _livePriceDictionary[assetName];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error {
    NSLog(@"WebSocket error: %@", error);
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean {
    NSLog(@"WebSocket closed: %@", reason);
}

- (void)authenticateWebSocketConnection {
    NSDictionary *authPayload = @{@"action": @"auth", @"key": @"PKYZ8FLRID2JGVKBLDJA", @"secret": @"ECVgORFsR9EunOvZrSBqmSgz9VzPHOJqTc9C2g0H"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authPayload options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendMessage:jsonString];
   
}

- (void)subscribeAssets:(NSArray<NSString *>*)assets {
    NSDictionary *authPayload = @{@"action": @"subscribe", @"quotes": @[@"AMZN", @"AAPL",@"MLGO", @"INTC"]};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authPayload options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendMessage:jsonString];
}

@end


/*

 AMZN, AAPL,MLGO, INTC,
 
*/
