//
//  AssetQuoteModel.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetQuoteModel : NSObject
@property(nonatomic, nonnull, strong) NSString *assetName;
@property(nonatomic, assign) Float32 bidPrice;
@property(nonatomic, assign) Float32 askPrice;

- (instancetype)initWithQuoteDictionary: (NSDictionary*) dict
                               forAsset: (NSString *)asset;
@end

NS_ASSUME_NONNULL_END
