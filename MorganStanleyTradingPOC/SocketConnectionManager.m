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
@end

@implementation SocketConnectionManager

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURL *url = [NSURL URLWithString:@"wss://stream.data.alpaca.markets/v2/iex"];
        self.webSocket = [[SRWebSocket alloc] initWithURL:url];
        self.webSocket.delegate = self;
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
    NSData *response;
    if([message isKindOfClass:[NSData class]]) {
        response = message;
    } else {
        response = [message dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:response options:0 error:&error];
    NSLog(@"received message %@", dict);
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

- (void)fetchPriceForSymbol:(NSString *)symbol {
    NSDictionary *authPayload = @{@"action": @"subscribe", @"trades": @[@"AAPL"]};
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authPayload options:0 error:nil];
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendMessage:jsonString];
}

@end
