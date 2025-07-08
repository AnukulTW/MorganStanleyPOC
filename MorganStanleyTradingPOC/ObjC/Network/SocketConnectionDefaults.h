//
//  DefaultSocketConnectionConfigurer.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 08/07/25.
//

#import "SocketConnectionEnabler.h"

NS_ASSUME_NONNULL_BEGIN
@interface SocketConnectionDefaults : NSObject <TradeDataKeysProvider>
@property (assign, nonatomic)BOOL isEnablePrimeAPI;
@end
NS_ASSUME_NONNULL_END
