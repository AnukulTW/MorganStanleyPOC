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
@end
