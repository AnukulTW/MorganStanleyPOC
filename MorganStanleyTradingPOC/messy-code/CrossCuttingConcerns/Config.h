//
//  Config.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 17/07/25.
//

@import Foundation;

@interface Config : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, strong) NSString *baseURL;
@property (nonatomic, strong) NSString *apiKey;
@property (nonatomic, strong) NSString *apiSecret;
-(NSString*)getAPISecret;
-(NSString*)getBaseURL;
-(NSString*)getAPIKey;
@end
