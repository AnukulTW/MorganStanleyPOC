#import "NetworkClient.h"

@implementation NetworkClient

+ (instancetype)sharedInstance {
    static NetworkClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

- (void)GET:(NSString *)urlString
 parameters:(NSDictionary *)parameters
    headers:(NSDictionary<NSString *, NSString *> *)headers
 completion:(void (^)(id _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error))completion {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLComponents *components = [NSURLComponents componentsWithString:urlString];
        if (parameters) {
            NSMutableArray *queryItems = [NSMutableArray array];
            [parameters enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
                [queryItems addObject:[NSURLQueryItem queryItemWithName:key value:[obj description]]];
            }];
            components.queryItems = queryItems;
        }
        NSURL *url = components.URL;
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        request.HTTPMethod = @"GET";
        if (headers) {
            [headers enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
                [request setValue:value forHTTPHeaderField:key];
            }];
        }
        NSURLSessionDataTask *task = [[NSURLSession sharedSession] dataTaskWithRequest:request
                                                                     completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            id responseObject = nil;
            if (data) {
                responseObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            }
            if (completion) {
                completion(responseObject, response, error);
            }
        }];
        [task resume];
    });
    
}

@end
