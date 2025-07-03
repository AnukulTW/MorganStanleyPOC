//
//  SocketConnectionManager.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN



@interface SocketConnectionManager : NSObject
- (void)fetchPriceForSymbol:(NSString *)symbol;
//@property (nonatomic, weak) id<SocketConnectionManagerDelegate> connectionDelegate;

@end

NS_ASSUME_NONNULL_END
