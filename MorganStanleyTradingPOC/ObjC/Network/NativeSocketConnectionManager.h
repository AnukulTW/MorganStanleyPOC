//
//  SocketConnectionManager 2.h
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 08/07/25.
//


#import <Foundation/Foundation.h>
#import "SocketConnectionEnabler.h"

NS_ASSUME_NONNULL_BEGIN
@interface NativeSocketConnectionManager : NSObject <SocketConnectionEnabler,NSURLSessionWebSocketDelegate>

@end

NS_ASSUME_NONNULL_END
