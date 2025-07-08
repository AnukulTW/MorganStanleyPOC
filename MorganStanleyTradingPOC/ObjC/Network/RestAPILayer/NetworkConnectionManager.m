//
//  NetworkConnectionManager.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "NetworkConnectionManager.h"
#import "MorganStanleyTradingPOC-Swift.h"

@interface NetworkConnectionManager ()
@property (nonatomic, strong) NSURLSession *urlSession;
@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *apiSecret;
@end

@implementation NetworkConnectionManager

- (instancetype)initWithAPIKey:(NSString *)apiKey
                    apiSecret:(NSString *)apiSecret {
    self = [super init];
    if (self) {
        _urlSession = [NSURLSession sharedSession];
        _apiKey = apiKey;
        _apiSecret = apiSecret;
    }
    return self;
}

- (void)sendRequestWithURL:(NSURL *)url
                    method:(NSString *)httpMethod
               queryParams:(nullable NSDictionary<NSString *, NSString *> *)queryParams
                   headers:(nullable NSDictionary<NSString *, NSString *> *)headers
                      body:(nullable NSData *)body
                completion:(NetworkCompletion)completion {

    NSURLComponents *components = [NSURLComponents componentsWithURL:url resolvingAgainstBaseURL:NO];
    
    if (queryParams) {
        NSMutableArray<NSURLQueryItem *> *queryItems = [NSMutableArray array];
        for (NSString *key in queryParams) {
            [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:queryParams[key]]];
        }
        components.queryItems = queryItems;
    }
    
    NSURL *finalURL = components.URL;
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:finalURL];
    request.HTTPMethod = httpMethod;
    request.HTTPBody = body;
    request.timeoutInterval = 10;

    // Default headers
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    if(Constants.isEnablePrimeAPI) {
        [request setValue: @"412a1eadfd-aee20f3516-sz2frh" forHTTPHeaderField:@"X-API-KEY"];
    } else {
        [request setValue:self.apiKey forHTTPHeaderField:@"APCA-API-KEY-ID"];
        [request setValue:self.apiSecret forHTTPHeaderField:@"APCA-API-SECRET-KEY"];
    }
    


    // Custom headers
    for (NSString *headerKey in headers) {
        [request setValue:headers[headerKey] forHTTPHeaderField:headerKey];
    }

    NSURLSessionDataTask *task = [self.urlSession dataTaskWithRequest:request
                                                    completionHandler:^(NSData * _Nullable data,
                                                                        NSURLResponse * _Nullable response,
                                                                        NSError * _Nullable error) {
        if (completion) {
            completion(data, error);
        }
    }];
    [task resume];
}

@end
