//
//  TradeController.m
//  MorganStanleyTradingPOC
//
//  Created by Shrey Shrivastava on 08/07/25.
//
#import <Foundation/Foundation.h>
#import "NativeSocketConnectionManager.h"
#import "TradeController.h"
#import "AssetPriceModel.h"

@interface TradeController()<NativeSocketConnectionManagerDelegate>
@property (nonatomic, nonnull, strong) NativeSocketConnectionManager *socket;
@property (strong, nonatomic, nonnull) NSMutableDictionary <NSString *, AssetPriceModel*>* livePriceDictionary;
@end

@implementation TradeController

-(instancetype)init{
    self.socket = [[NativeSocketConnectionManager alloc] init];
    self.socket.connectionDelegate = self;
}

-(void) startSocket{
    [self.socket connect];
}

-(void)

@end
