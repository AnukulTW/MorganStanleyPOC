//
//  TradingManager.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 17/07/25.
//

#import "Config.h"
@interface TradingManager : NSObject
+ (instancetype)sharedInstance;
@property (nonatomic, strong) Config *config;
-(void)fetchRemoteConfigs;
- (void)getMostActiveStocksWithCompletion:(void (^)(NSArray *stocks))completion;
- (void)getTopMoversWithCompletion:(void (^)(NSArray *movers))completion;
- (void)getLatestNewsWithCompletion:(void (^)(NSArray *news))completion;
@end
