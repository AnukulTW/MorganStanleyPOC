//
//  AssetTableViewCell.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "AssetTableViewCell.h"


@interface AssetTableViewCell()
@property (nonatomic, nonnull ,strong) UILabel *assetName;
@property (nonatomic, nonnull ,strong) UILabel *assetSymbol;
@property (nonatomic, nonnull ,strong) UILabel *assetType;
@property (nonatomic, nonnull ,strong) UILabel *assetLivePrice;
@property (nonatomic, nonnull ,strong) UIStackView *assetInfoStack;
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
    [_assetInfoStack addArrangedSubview: _assetSymbol];
    [_assetInfoStack addArrangedSubview: _assetType];
    [_assetInfoStack addArrangedSubview: _assetLivePrice];

    [NSLayoutConstraint activateConstraints: @[
        [_assetInfoStack.leadingAnchor constraintEqualToAnchor: self.contentView.leadingAnchor constant: 20],
        [_assetInfoStack.topAnchor constraintEqualToAnchor: self.contentView.topAnchor constant: 8.0],
        [_assetInfoStack.trailingAnchor constraintEqualToAnchor: self.contentView.trailingAnchor constant: -20],
        [_assetInfoStack .bottomAnchor constraintEqualToAnchor: self.contentView.bottomAnchor constant: -8.0],
    ]];
}


- (void)setupUI {
    [self setupAssetNameLabel];
    [self setupAssetSymbolLabel];
    [self setupAssetTypeLabel];
    [self setupAssetLivePriceLabel];
    [self setupAssetInfoStack];
}

- (void)setupAssetNameLabel {
    _assetName = [[UILabel alloc]init];
    _assetName.translatesAutoresizingMaskIntoConstraints = NO;
    _assetName.font = [UIFont boldSystemFontOfSize: 16];
    _assetName.textColor = [UIColor blackColor];
}

- (void)setupAssetSymbolLabel {
    _assetSymbol = [[UILabel alloc]init];
    _assetSymbol.translatesAutoresizingMaskIntoConstraints = NO;
    _assetSymbol.font = [UIFont systemFontOfSize: 14];
    _assetSymbol.textColor = [UIColor blackColor];
}

- (void)setupAssetTypeLabel {
    _assetType = [[UILabel alloc]init];
    _assetType.translatesAutoresizingMaskIntoConstraints = NO;
    _assetType.font = [UIFont systemFontOfSize: 14];
    _assetType.textColor = [UIColor blackColor];
}

- (void)setupAssetLivePriceLabel {
    _assetLivePrice = [[UILabel alloc]init];
    _assetLivePrice.translatesAutoresizingMaskIntoConstraints = NO;
    _assetLivePrice.font = [UIFont systemFontOfSize: 14];
    _assetLivePrice.textColor = [UIColor blackColor];
}

- (void)setupAssetInfoStack {
    _assetInfoStack = [[UIStackView alloc]init];
    _assetInfoStack.translatesAutoresizingMaskIntoConstraints = NO;
    _assetInfoStack.axis = UILayoutConstraintAxisVertical;
    _assetInfoStack.distribution = UIStackViewDistributionFill;
    _assetInfoStack.spacing = 4.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureCell:(AssetModel *)model livePice: (NSString *)price {
    _assetName.text = model.name;
    _assetSymbol.text = model.symbol;
    _assetType.text = [model.assetType uppercaseString];
    _assetLivePrice.text = price;
}

@end
