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
    [self startSocket];
    return self;
}

-(void) startSocket{
    [self.socket connect];
}

- (void)didReceiveMessage:(nonnull NSString *)message {
    NSError *error;
    NSData *data = [message dataUsingEncoding:NSASCIIStringEncoding];
    id response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if([response isKindOfClass: [NSDictionary class]]) {
        NSDictionary* responseDict = response;
        NSArray<NSString*> *keys = responseDict.allKeys;
        if(responseDict != NULL && [keys containsObject: @"sym"]) {
            [self parseResponse:responseDict];
        }
    }
}

- (void)parseResponse: (NSDictionary *)responseDict {
    
    NSString *assetSymbol = responseDict[@"sym"];
    NSArray<NSString*> *keys = responseDict.allKeys;
    
    if(_livePriceDictionary[assetSymbol] == NULL) {
        if([keys containsObject: @"sym"] &&
           [keys containsObject: @"bid"] &&
           [keys containsObject: @"ask"] &&
           responseDict[@"sym"] != NULL &&
           responseDict[@"bid"] != NULL &&
           responseDict[@"ask"] != NULL
           ) {
            NSString *assetSymbol = responseDict[@"sym"];
            
            Float32 currentBidPrice = [responseDict[@"bid"] floatValue];
            Float32 currentAskPrice = [responseDict[@"ask"] floatValue];
            
            NSUInteger bidPriceDirection = 0;
            NSUInteger askPriceDirection = 0;
            
            AssetPriceModel *priceModel = [[AssetPriceModel alloc]initWithQuoteDictionary: @{
                @"bidPrice": @(currentBidPrice),
                @"askPrice": @(currentAskPrice),
                @"bidPriceDirection": @(bidPriceDirection),
                @"askPriceDirection": @(askPriceDirection)
            }];
            
            
            _livePriceDictionary[assetSymbol] = priceModel;
            //[_connectionDelegate didReceivePrice: priceModel forAsset:assetSymbol];
            [self.handler didReceivePrice:priceModel forAsset:assetSymbol];
        }
    } else {
            
            
            if([keys containsObject: @"sym"] &&
               [keys containsObject: @"bid"] &&
               [keys containsObject: @"ask"] &&
               responseDict[@"sym"] != NULL &&
               responseDict[@"bid"] != NULL &&
               responseDict[@"ask"] != NULL
               ) {
                
                
                AssetPriceModel *model = [self updatePriceModel:responseDict];
                _livePriceDictionary[assetSymbol] = model;
                [self.handler didReceivePrice:model forAsset:assetSymbol];
            }
            
        }
}

- (AssetPriceModel *)updatePriceModel: (NSDictionary *)responseDict {
    @autoreleasepool {
        NSString *assetSymbol = responseDict[@"sym"];
        AssetPriceModel *previousModel = _livePriceDictionary[assetSymbol];
        
        Float32 previousBidPrice = previousModel.bidPrice.price;
        Float32 previousAskPrice = previousModel.askPrice.price;
        
        Float32 currentBidPrice = [responseDict[@"bid"] floatValue];
        Float32 currentAskPrice = [responseDict[@"ask"] floatValue];
        
        if(currentAskPrice == previousAskPrice && currentBidPrice == previousBidPrice) {
            NSLog(@"Return printed");
            return previousModel;
        }
        
        NSUInteger bidPriceDirection = currentBidPrice > previousBidPrice ? 1 : 2;
        NSUInteger askPriceDirection = currentAskPrice > previousAskPrice ? 1 : 2;
        
        
        [previousModel updatePriceModel: @{
            @"bidPrice": @(currentBidPrice),
            @"askPrice": @(currentAskPrice),
            @"bidPriceDirection": @(bidPriceDirection),
            @"askPriceDirection": @(askPriceDirection)
        }];
        
        return  previousModel;
    }
}

- (void)subscribeAssets:(NSArray<NSString *>*)assets {
    [self.socket subscribeAssets:assets];
}


- (nonnull AssetPriceModel *)fetchPrice:(nonnull NSString *)assetName {
    NSLog(@"Value %@",_livePriceDictionary[assetName]);
    return  _livePriceDictionary[assetName];
}

@end

