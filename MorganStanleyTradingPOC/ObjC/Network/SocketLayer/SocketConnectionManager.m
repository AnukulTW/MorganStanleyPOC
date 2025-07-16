//
//  SocketConnectionManager.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "SocketConnectionManager.h"
#import <SocketRocket/SRWebSocket.h>
#import "MorganStanleyTradingPOC-Swift.h"

#import "SocketConnectionDefaults.h"

@interface SocketConnectionManager()<SRWebSocketDelegate>
@property (strong, nonatomic) SRWebSocket *webSocket;
@property (strong, nonatomic, nonnull) NSMutableDictionary <NSString *, AssetPriceModel*>* livePriceDictionary;
@property (nonatomic, strong) dispatch_queue_t socketQueue;
@property (nonatomic, strong) NSMutableDictionary <NSString*, AssetPriceModel *>*pendingMessages;
@property (assign, nonatomic)BOOL isEnablePrimeAPI;
@end

@implementation SocketConnectionManager
@synthesize connectionDelegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        _socketQueue = dispatch_queue_create("com.yourapp.socketQueue", DISPATCH_QUEUE_SERIAL);
        _isEnablePrimeAPI = Constants.isEnablePrimeAPI;
        NSURL *url = [self createURL];
        self.webSocket = [[SRWebSocket alloc] initWithURL:url];
        self.webSocket.delegate = self;
        self.webSocket.delegateDispatchQueue = _socketQueue;
        _livePriceDictionary = [[NSMutableDictionary alloc]init];
    }
    
    return self;
}

- (NSURL *)createURL {
    NSString *baseURL = _isEnablePrimeAPI ? @"wss://euc2.primeapi.io" : @"wss://stream.data.alpaca.markets/v2/iex";
    return [NSURL URLWithString: baseURL];
}

- (NSDictionary *)authDictionary {
    if (_isEnablePrimeAPI) {
        return @{
            @"op": @"auth",
            @"key": @"11d868a349-51e423f8ee-szhlbx"
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
    [self.connectionDelegate connectionEstablishSuccess];
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message {
    [self.connectionDelegate didReceiveMessage:message];
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

- (void)connect { 
    dispatch_async(_socketQueue, ^{
        [self.webSocket open];
    });
}


- (void)disconnect { 
    [self.webSocket close];
}


- (void)receiveMessages { 
    
}


- (void)reconnect { 
    
}


@end


/*

 AMZN, AAPL,MLGO, INTC,
 
*/
