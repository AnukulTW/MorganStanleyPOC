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
#import "SocketConnectionDefaults.h"
#import "AssetQuoteModel.h"
#import "MorganStanleyTradingPOC-Swift.h"

@interface TradeController()<SocketConnectionManagerDelegate>
@property (strong, nonatomic, nonnull) NSMutableDictionary <NSString *, AssetPriceModel*>* livePriceDictionary;
@property (nonatomic, strong) id<SocketConnectionEnabler> socketEnabler;
@property (strong, nonatomic) SocketConnectionDefaults *connectionDefaults;
@property (nonatomic, strong) dispatch_queue_t livePriceSerialQueue;
@end

@implementation TradeController

- (instancetype)initWithSocketEnabler:(id<SocketConnectionEnabler>)enabler{
    self.socketEnabler = enabler;
    self.socketEnabler.connectionDelegate = self;
    _connectionDefaults = [[SocketConnectionDefaults alloc] init];
    _connectionDefaults.isEnablePrimeAPI = Constants.isEnablePrimeAPI;
    _livePriceDictionary = [[NSMutableDictionary alloc] init];
    _livePriceSerialQueue = dispatch_queue_create("com.myapp.serialQueue", DISPATCH_QUEUE_SERIAL);
    [self startSocket];
    return self;
}

-(void)startSocket {
    [self.socketEnabler connect];
}

- (void)didReceiveMessage:(nonnull id)message {
    NSData *responseData;
    if([message isKindOfClass:[NSData class]]) {
        responseData = message;
    } else {
        responseData = [message dataUsingEncoding:NSUTF8StringEncoding];
    }
    NSError *error;
    NSDictionary* responseDict;
    id response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&error];
    
    if([response isKindOfClass: [NSArray class]]) {
        responseDict = [response lastObject];
    } else if([response isKindOfClass: [NSDictionary class]]) {
        responseDict = response;
    }
    
    NSArray<NSString*> *keys = responseDict.allKeys;
    NSString *assetNameKey = [self.connectionDefaults assetNameKey];
    if(responseDict != NULL && [keys containsObject: assetNameKey]) {
        [self parseResponse:responseDict];
    }
}

- (void)connectionEstablishSuccess {
    [self.handler connectionEstablishSuccess];
}

- (void)parseResponse: (NSDictionary *)responseDict {
    __weak typeof(self) weakSelf = self;

    dispatch_async(_livePriceSerialQueue, ^{
        NSArray<NSString*> *keys = responseDict.allKeys;
        NSString *assetNameKey = [self.connectionDefaults assetNameKey];
        NSString *bidPriceKey = [self.connectionDefaults bidPriceKey];
        NSString *askPriceKey = [self.connectionDefaults askPriceKey];
        
        if([keys containsObject:assetNameKey] &&
           [keys containsObject: bidPriceKey] &&
           [keys containsObject: askPriceKey] &&
           responseDict[assetNameKey] != NULL &&
           responseDict[bidPriceKey] != NULL &&
           responseDict[askPriceKey] != NULL
           ) {
            
            NSString *assetName = responseDict[assetNameKey];
            AssetPriceModel *priceModel;
            if(weakSelf.livePriceDictionary[assetName] == NULL) {
                
                Float32 currentBidPrice = [responseDict[bidPriceKey] floatValue];
                Float32 currentAskPrice = [responseDict[askPriceKey] floatValue];
                
                NSUInteger bidPriceDirection = 0;
                NSUInteger askPriceDirection = 0;
                
                priceModel = [[AssetPriceModel alloc]initWithQuoteDictionary: @{
                    @"bidPrice": @(currentBidPrice),
                    @"askPrice": @(currentAskPrice),
                    @"bidPriceDirection": @(bidPriceDirection),
                    @"askPriceDirection": @(askPriceDirection)
                }];
                
            } else {
                priceModel = [self updatePriceModel:responseDict];
            }
            
            weakSelf.livePriceDictionary[assetName] = priceModel;
            
            NSDictionary *userInfo = @{@"priceModel": priceModel};
            NSString *notificationName = [@"AssetPriceDidChange_" stringByAppendingString:assetName];

            [[NSNotificationCenter defaultCenter] postNotificationName: notificationName
                                                                object:nil
                                                              userInfo:userInfo];
            
            [self.handler didReceivePrice: priceModel forAsset:assetName];
        }
    });

}

- (AssetPriceModel *)updatePriceModel: (NSDictionary *)responseDict {
    NSString *assetNameKey = [self.connectionDefaults assetNameKey];
    NSString *bidPriceKey = [self.connectionDefaults bidPriceKey];
    NSString *askPriceKey = [self.connectionDefaults askPriceKey];
    
    NSString *assetSymbol = responseDict[assetNameKey];
    AssetPriceModel *previousModel = _livePriceDictionary[assetSymbol];
    
    Float32 previousBidPrice = previousModel.bidPrice.price;
    Float32 previousAskPrice = previousModel.askPrice.price;
    
    Float32 currentBidPrice = [responseDict[bidPriceKey] floatValue];
    Float32 currentAskPrice = [responseDict[askPriceKey] floatValue];
    
    if(currentAskPrice == previousAskPrice && currentBidPrice == previousBidPrice) {
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

- (void)subscribeAssets:(NSArray<NSString *>*)assets {
    [self.socketEnabler subscribeAssets:assets];
}


- (nonnull AssetPriceModel *)fetchPrice:(nonnull NSString *)assetName {
    __block AssetPriceModel *value;

    // Blocking the operation and will not proceed ahead
    dispatch_sync(_livePriceSerialQueue, ^{
        value = _livePriceDictionary[assetName];
    });
    
    return value;
}

- (void)updateAssetLastQuote:(NSArray<AssetQuoteModel*> *)assetQuoteArray {
    __weak typeof(self) weakSelf = self;

    dispatch_async(_livePriceSerialQueue, ^{
        for(AssetQuoteModel * assetQuote in assetQuoteArray) {
            NSString *assetName = assetQuote.assetName;
            if(weakSelf.livePriceDictionary[assetName] == NULL) {
                
                NSUInteger bidPriceDirection = 0;
                NSUInteger askPriceDirection = 0;
                
                AssetPriceModel *priceModel = [[AssetPriceModel alloc]initWithQuoteDictionary: @{
                    @"bidPrice": @(assetQuote.bidPrice),
                    @"askPrice": @(assetQuote.askPrice),
                    @"bidPriceDirection": @(bidPriceDirection),
                    @"askPriceDirection": @(askPriceDirection)
                }];
                
                weakSelf.livePriceDictionary[assetName] = priceModel;
            }
        }
    });
}

@end

