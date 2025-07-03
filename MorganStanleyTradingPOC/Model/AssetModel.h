//
//  AssetModel.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AssetModel : NSObject
@property(nonatomic, nonnull, strong) NSString *identifier;
@property(nonatomic, nonnull, strong) NSString *assetType;
@property(nonatomic, nonnull, strong) NSString *symbol ;
@property(nonatomic, nonnull, strong) NSString *name;

- (instancetype)initWithDictionary: (NSDictionary*) dict;
@end

NS_ASSUME_NONNULL_END
