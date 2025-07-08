//
//  NativeSocketConnectionManager.m
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 08/07/25.
//

#import "NativeSocketConnectionManager.h"

@interface NativeSocketConnectionManager ()
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionWebSocketTask *webSocketTask;
@property (assign, nonatomic) BOOL isConnected;
@end

@implementation NativeSocketConnectionManager

NSString * const kWebSocketURLString = @"wss://euc2.primeapi.io";
NSString * const kAuthKey = @"271a3da4f2-be99aec8bd-sz2vu6";

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

    NSURL *url = [NSURL URLWithString:kWebSocketURLString];
    self.webSocketTask = [self.session webSocketTaskWithURL:url];
    [self.webSocketTask resume];

    self.isConnected = YES;

    // Authenticate
    NSDictionary *authPayload = @{
        @"op": @"auth",
        @"key": kAuthKey
    };
    NSData *authData = [NSJSONSerialization dataWithJSONObject:authPayload options:0 error:nil];
    NSString *authString = [[NSString alloc] initWithData:authData encoding:NSUTF8StringEncoding];
    [self sendMessage:authString];

    [self receiveMessages];
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
    // NSDictionary *authPayload = @{@"action": @"subscribe", @"quotes": @[@"AMZN", @"AAPL",@"MLGO", @"INTC"]};
    //NSDictionary *authPayload = @{@"action": @"subscribe", @"quotes": @[@"AVAX/USD", @"BTC/USD"]};
    NSDictionary *authPayload = @{@"op": @"subscribe", @"pairs": assets, @"stream": @"fx"};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authPayload options:0 error:nil];
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

@end
