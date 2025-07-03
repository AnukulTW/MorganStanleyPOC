//
//  AssetTableViewCell.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import <UIKit/UIKit.h>
#import "Model/AssetModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AssetTableViewCell : UITableViewCell
- (void)configureCell:(AssetModel *)model livePice: (NSString *)price ;
@end

NS_ASSUME_NONNULL_END
