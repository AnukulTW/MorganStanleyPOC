//
//  Config.m
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 17/07/25.
//

@import Firebase;
#import "Config.h"

@interface Config()
@property (nonatomic, strong) FIRRemoteConfig *remoteConfig;
@end

@implementation Config

+ (instancetype)sharedInstance {
    static Config *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Config alloc] init];
        [instance initializeRemoteConfig];
    });
    return instance;
}

- (void)initializeRemoteConfig {
    self.remoteConfig = [FIRRemoteConfig remoteConfig];
    FIRRemoteConfigSettings *remoteConfigSettings = [[FIRRemoteConfigSettings alloc] init];
    remoteConfigSettings.minimumFetchInterval = 3600; // 1 hour
    self.remoteConfig.configSettings = remoteConfigSettings;
}

-(NSString*)getBaseURL {
    return [self.remoteConfig configValueForKey:@"BaseURL"].stringValue ?: @"https://default-api.example.com";
}

-(NSString*)getAPIKey {
    return [self.remoteConfig configValueForKey:@"APIKey"].stringValue ?: @"default-api-key";
}

-(NSString*)getAPISecret {
    return [self.remoteConfig configValueForKey:@"APISecret"].stringValue ?: @"default-api";
}

@end
