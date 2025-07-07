//
//  AssetTableViewCell.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "AssetTableViewCell.h"


@interface AssetTableViewCell()
@property (nonatomic, nonnull ,strong) UILabel *assetName;
@property (nonatomic, nonnull ,strong) UILabel *assetBidPrice;
@property (nonatomic, nonnull ,strong) UILabel *assetAskPrice;
@property (nonatomic, nonnull ,strong) UIStackView *assetInfoStack;
@property (nonatomic, nonnull ,strong) UIStackView *assetPriceInfoStack;

@end


@implementation AssetTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupUI];
        [self setupConstraints];
    }
    
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupConstraints {
    [self.contentView addSubview: _assetInfoStack];
    [_assetInfoStack addArrangedSubview: _assetName];
    //[_assetInfoStack addArrangedSubview: _assetPriceInfoStack];
    [_assetInfoStack addArrangedSubview: _assetBidPrice];
    [_assetInfoStack addArrangedSubview: _assetAskPrice];

    [NSLayoutConstraint activateConstraints: @[
        [_assetInfoStack.leadingAnchor constraintEqualToAnchor: self.contentView.leadingAnchor constant: 20],
        [_assetInfoStack.topAnchor constraintEqualToAnchor: self.contentView.topAnchor constant: 8.0],
        [_assetInfoStack.trailingAnchor constraintEqualToAnchor: self.contentView.trailingAnchor constant: -20],
        [_assetInfoStack .bottomAnchor constraintEqualToAnchor: self.contentView.bottomAnchor constant: -8.0],
    ]];
    
    [_assetInfoStack setCustomSpacing:4.0 afterView: _assetBidPrice];
}


- (void)setupUI {
    [self setupAssetNameLabel];
    [self setupAssetSymbolLabel];
    [self setupAssetLivePriceLabel];
    [self setupAssetInfoStack];
    [self setupAssetPriceInfoStack];
}

- (void)setupAssetNameLabel {
    _assetName = [[UILabel alloc]init];
    _assetName.translatesAutoresizingMaskIntoConstraints = NO;
    _assetName.font = [UIFont boldSystemFontOfSize: 18];
    _assetName.textColor = [UIColor blackColor];
}

- (void)setupAssetSymbolLabel {
    _assetBidPrice = [[UILabel alloc]init];
    _assetBidPrice.translatesAutoresizingMaskIntoConstraints = NO;
    _assetBidPrice.font = [UIFont systemFontOfSize: 16.0];
    _assetBidPrice.textColor = [UIColor blackColor];
}

- (void)setupAssetLivePriceLabel {
    _assetAskPrice = [[UILabel alloc]init];
    _assetAskPrice.translatesAutoresizingMaskIntoConstraints = NO;
    _assetAskPrice.font = [UIFont systemFontOfSize: 16.0];
    _assetAskPrice.textColor = [UIColor blackColor];
}

- (void)setupAssetInfoStack {
    _assetInfoStack = [[UIStackView alloc]init];
    _assetInfoStack.translatesAutoresizingMaskIntoConstraints = NO;
    _assetInfoStack.axis = UILayoutConstraintAxisVertical;
    _assetInfoStack.distribution = UIStackViewDistributionFill;
    _assetInfoStack.spacing = 10.0;
}

- (void)setupAssetPriceInfoStack {
    _assetPriceInfoStack = [[UIStackView alloc]init];
    _assetPriceInfoStack.translatesAutoresizingMaskIntoConstraints = NO;
    _assetPriceInfoStack.axis = UILayoutConstraintAxisHorizontal;
    _assetPriceInfoStack.distribution = UIStackViewDistributionFillEqually;
    _assetPriceInfoStack.spacing = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCell:(AssetModel *)model livePice: (AssetPriceModel *)price {
    _assetName.text = [[model.symbol stringByAppendingString:@" - "] stringByAppendingString: model.name ];
    NSString *bidPriceString = [NSString stringWithFormat:@"%.2f", price.bidPrice];
    NSString *askPriceString = [NSString stringWithFormat:@"%.2f", price.askPrice];
    _assetBidPrice.text = [@"Bid Price : " stringByAppendingString: bidPriceString];
    _assetAskPrice.text = [@"Ask Price : " stringByAppendingString: askPriceString];
}

@end
