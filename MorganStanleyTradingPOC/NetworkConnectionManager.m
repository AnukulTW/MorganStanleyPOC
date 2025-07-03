//
//  NetworkConnectionManager.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "NetworkConnectionManager.h"

@interface NetworkConnectionManager()
@property (strong, nonatomic) NSURLSession *urlSession;
@end

@implementation NetworkConnectionManager

- (instancetype)init {
    self = [super init];
    if (self) {
        _urlSession = [NSURLSession sharedSession];
    }
    return self;
}


- (void)fetchData:(void (^)(NSData* _Nullable , NSError* _Nullable))completion {
    
    NSURL *baseURL = [[NSURL alloc]initWithString: @"https://paper-api.alpaca.markets/v2/assets"];
    NSURLComponents *components = [NSURLComponents componentsWithURL:baseURL resolvingAgainstBaseURL:NO];
    NSURLQueryItem *queryItem = [NSURLQueryItem queryItemWithName:@"status" value:@"active"];
    components.queryItems = @[queryItem];
    NSURL *finalURL = components.URL;

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:finalURL];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"PKYZ8FLRID2JGVKBLDJA" forHTTPHeaderField:@"APCA-API-KEY-ID"];
    [request setValue:@"ECVgORFsR9EunOvZrSBqmSgz9VzPHOJqTc9C2g0H" forHTTPHeaderField:@"APCA-API-SECRET-KEY"];
    
    NSURLSessionDataTask *task = [_urlSession dataTaskWithRequest: request
                                                completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        completion(data, error);
    }];
    
    [task resume];
}

@end
