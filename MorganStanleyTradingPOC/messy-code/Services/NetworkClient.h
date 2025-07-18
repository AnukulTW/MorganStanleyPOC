#import <Foundation/Foundation.h>

@interface NetworkClient : NSObject

+ (instancetype)sharedInstance;

- (void)GET:(NSString *)urlString
 parameters:(NSDictionary *)parameters
    headers:(NSDictionary<NSString *, NSString *> *)headers
 completion:(void (^)(id _Nullable responseObject, NSURLResponse * _Nullable response, NSError * _Nullable error))completion;

@end
