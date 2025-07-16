//
//  NativeSocketConnectionManager.m
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 08/07/25.
//

#import "NativeSocketConnectionManager.h"
#import "SocketConnectionDefaults.h"
#import "MorganStanleyTradingPOC-Swift.h"

@interface NativeSocketConnectionManager ()
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionWebSocketTask *webSocketTask;
@property (assign, nonatomic) BOOL isConnected;
@end

@implementation NativeSocketConnectionManager
@synthesize connectionDelegate;
//NSString * const kWebSocketURLString = @"wss://euc2.primeapi.io";
//NSString * const kAuthKey = @"11d868a349-51e423f8ee-szhlbx";

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config];
    }
    return self;
}

- (void)connect {
    if (self.isConnected) return;

    NSURL *url = [self createURL];
    self.webSocketTask = [self.session webSocketTaskWithURL:url];
    [self.webSocketTask resume];

    self.isConnected = YES;
    [self authenticateWebSocketConnection];
    
}

- (void)sendMessage:(NSString *)message {
    if (!self.webSocketTask) return;

    NSURLSessionWebSocketMessage *wsMessage = [[NSURLSessionWebSocketMessage alloc] initWithString:message];
    [self.webSocketTask sendMessage:wsMessage completionHandler:^(NSError * _Nullable error) {
        if (error) {
            NSLog(@"Send error: %@", error.localizedDescription);
        }
    }];
}

- (void)receiveMessages {
    if (!self.webSocketTask) return;

    [self.webSocketTask receiveMessageWithCompletionHandler:^(NSURLSessionWebSocketMessage * _Nullable message, NSError * _Nullable error) {
        if (error) {
            NSLog(@"Receive error: %@", error.localizedDescription);
            [self reconnect];
            return;
        }
        
        if (message.type == NSURLSessionWebSocketMessageTypeString) {
            NSString *dataString = message.string;
            if ([self.connectionDelegate respondsToSelector:@selector(didReceiveMessage:)]) {
                [self.connectionDelegate didReceiveMessage:dataString];
            }
        }
        

        // Listen again
        [self receiveMessages];
    }];
}

- (void)subscribeAssets:(NSArray<NSString *>*)assets {
    NSDictionary *subscriptionDict = [self livePriceSubcriptionDictionary: assets];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subscriptionDict options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendMessage:jsonString];
}

- (void)disconnect {
    [self.webSocketTask cancelWithCloseCode:NSURLSessionWebSocketCloseCodeNormalClosure reason:nil];
    self.webSocketTask = nil;
    self.isConnected = NO;
}

- (void)reconnect {
    NSLog(@"Reconnecting...");
    self.isConnected = NO;
    [self connect];
}


- (void)authenticateWebSocketConnection { 
    NSDictionary *authPayload = [self authDictionary];
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authPayload options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendMessage:jsonString];
    [self receiveMessages];
}

- (void) URLSession:(NSURLSession *) session
      webSocketTask:(NSURLSessionWebSocketTask *) webSocketTask
didOpenWithProtocol:(NSString *) protocol{
    [self.connectionDelegate connectionEstablishSuccess];
}

- (nonnull NSURL *)createURL {
    NSString *baseURL = Constants.isEnablePrimeAPI ? @"wss://euc2.primeapi.io" : @"wss://stream.data.alpaca.markets/v2/iex";
    return [NSURL URLWithString: baseURL];
}

- (nonnull NSDictionary *)authDictionary {
    if (Constants.isEnablePrimeAPI) {
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

- (nonnull NSDictionary *)livePriceSubcriptionDictionary:(nonnull NSArray<NSString *> *)assets {
    if(Constants.isEnablePrimeAPI) {
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



@end
