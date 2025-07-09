//
//  ThreadedSocketConnectionManager.m
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 09/07/25.
//

#import <Foundation/Foundation.h>
#import "ThreadedSocketConnectionManager.h"
#import "MorganStanleyTradingPOC-Swift.h"

@interface ThreadedSocketConnectionManager ()
@property (strong, nonatomic) NSURLSession *session;
@property (strong, nonatomic) NSURLSessionWebSocketTask *webSocketTask;
@property (assign, nonatomic) BOOL isConnected;
@property (assign, nonatomic)BOOL isEnablePrimeAPI;

// Thread pinning
@property (strong, nonatomic) NSThread *socketThread;
@property (strong, nonatomic) NSRunLoop *socketRunLoop;
@end

@implementation ThreadedSocketConnectionManager
@synthesize connectionDelegate;

- (instancetype)init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:nil];
        _socketThread = [[NSThread alloc] initWithTarget:self selector:@selector(socketThreadEntryPoint) object:nil];
        _isEnablePrimeAPI = Constants.isEnablePrimeAPI;
        [_socketThread start];
    }
    return self;
}

- (void)dealloc {
    [self performBlockOnSocketThread:^{
        [self disconnect];
        CFRunLoopStop([self.socketRunLoop getCFRunLoop]);
    }];
}

#pragma mark - Thread Entry

- (void)socketThreadEntryPoint {
    @autoreleasepool {
        self.socketRunLoop = [NSRunLoop currentRunLoop];
        [[NSThread currentThread] setName:@"SocketThread"];
        [self.socketRunLoop addPort:[NSMachPort port] forMode:NSDefaultRunLoopMode];
        [self.socketRunLoop run];
    }
}

- (void)performBlockOnSocketThread:(dispatch_block_t)block {
    if ([[NSThread currentThread] isEqual:self.socketThread]) {
        block();
    } else {
        [self performSelector:@selector(executeBlock:)
                     onThread:self.socketThread
                   withObject:[block copy]
                waitUntilDone:NO];
    }
}

- (void)executeBlock:(dispatch_block_t)block {
    block();
}

#pragma mark - Connection Handling

- (void)connect {
    [self performBlockOnSocketThread:^{
        if (self.isConnected) return;

        NSURL *url = [self createURL];
        self.webSocketTask = [self.session webSocketTaskWithURL:url];
        [self.webSocketTask resume];
        
        self.isConnected = YES;
        [self authenticateWebSocketConnection];
    }];
}

- (void)disconnect {
    if (!self.webSocketTask) return;
    
    [self.webSocketTask cancelWithCloseCode:NSURLSessionWebSocketCloseCodeNormalClosure reason:nil];
    self.webSocketTask = nil;
    self.isConnected = NO;
}

- (void)reconnect {
    [self performBlockOnSocketThread:^{
        NSLog(@"Reconnecting...");
        self.isConnected = NO;
        [self connect];
    }];
}

#pragma mark - Message Handling

- (void)sendMessage:(NSString *)message {
    [self performBlockOnSocketThread:^{
        if (!self.webSocketTask) return;
        
        NSURLSessionWebSocketMessage *wsMessage = [[NSURLSessionWebSocketMessage alloc] initWithString:message];
        [self.webSocketTask sendMessage:wsMessage completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"Send error: %@", error.localizedDescription);
            }
        }];
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.connectionDelegate didReceiveMessage:dataString];
                });
            }
        }

        // Recursively listen for next message
        [self receiveMessages];
    }];
}

- (void)subscribeAssets:(NSArray<NSString *>*)assets {
    NSDictionary *subscriptionDict = [self livePriceSubcriptionDictionary:assets];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:subscriptionDict options:0 error:&error];
    if (error) {
        NSLog(@"Subscription JSON error: %@", error.localizedDescription);
        return;
    }

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendMessage:jsonString];
}

- (void)authenticateWebSocketConnection {
    NSDictionary *authPayload = [self authDictionary];
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:authPayload options:0 error:&error];
    if (error) {
        NSLog(@"Auth JSON error: %@", error.localizedDescription);
        return;
    }

    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    [self sendMessage:jsonString];
    [self receiveMessages];
}

#pragma mark - URLSession Delegate

- (void)URLSession:(NSURLSession *)session
     webSocketTask:(NSURLSessionWebSocketTask *)webSocketTask
didOpenWithProtocol:(NSString *)protocol {
    if ([self.connectionDelegate respondsToSelector:@selector(connectionEstablishSuccess)]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.connectionDelegate connectionEstablishSuccess];
        });
    }
}

#pragma mark - Helpers

- (NSURL *)createURL {
    NSString *baseURL = _isEnablePrimeAPI ? @"wss://euc2.primeapi.io" : @"wss://stream.data.alpaca.markets/v2/iex";
    return [NSURL URLWithString:baseURL];
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

- (NSDictionary *)livePriceSubcriptionDictionary:(NSArray<NSString *> *)assets {
    if (_isEnablePrimeAPI) {
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
