//
//  AssetTableViewCell.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "AssetTableViewCell.h"
#import "AssetPriceView.h"


@interface AssetTableViewCell()
@property (nonatomic, nonnull ,strong) UILabel *assetName;
@property (nonatomic, nonnull ,strong) UILabel *assetBidPrice;
@property (nonatomic, nonnull ,strong) UILabel *assetAskPrice;
@property (nonatomic, nonnull ,strong) UIStackView *assetInfoStack;
@property (nonatomic, nonnull ,strong) UIView *assetInfoView;

@property (nonatomic, nonnull ,strong) UIStackView *assetPriceInfoStack;
@property (nonatomic, nonnull ,strong) AssetPriceView *assetBidPriceView;
@property (nonatomic, nonnull ,strong) AssetPriceView *assetAskPriceView;

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
    [self.contentView addSubview: _assetName];
    [self.contentView addSubview: _assetPriceInfoStack];

    [_assetPriceInfoStack addArrangedSubview: _assetBidPriceView];
    [_assetPriceInfoStack addArrangedSubview: _assetAskPriceView];

    [NSLayoutConstraint activateConstraints: @[
        [_assetName.leadingAnchor constraintEqualToAnchor: self.contentView.leadingAnchor constant: 20],
        [_assetName.topAnchor constraintEqualToAnchor: self.contentView.topAnchor constant: 12.0],
        //[_assetInfoStack.trailingAnchor constraintEqualToAnchor: self.contentView.trailingAnchor constant: -20],
        [_assetName .bottomAnchor constraintEqualToAnchor: self.contentView.bottomAnchor constant: -12.0],
        [_assetName.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier: 0.4]
    ]];
    
    [NSLayoutConstraint activateConstraints: @[
        [_assetPriceInfoStack.leadingAnchor constraintEqualToAnchor: _assetName.trailingAnchor constant: 10],
        [_assetPriceInfoStack.topAnchor constraintEqualToAnchor: self.contentView.topAnchor constant: 12.0],
        [_assetPriceInfoStack.trailingAnchor constraintEqualToAnchor: self.contentView.trailingAnchor constant: -10],
        [_assetPriceInfoStack .bottomAnchor constraintEqualToAnchor: self.contentView.bottomAnchor constant: -12.0],
        [_assetPriceInfoStack.widthAnchor constraintEqualToAnchor:self.contentView.widthAnchor multiplier: 0.5]

    ]];
}


- (void)setupUI {
    [self setupAssetNameLabel];
    [self setupAssetAskPriceView];
    [self setupAssetBidPriceView];
    [self setupAssetInfoStack];
    [self setupAssetPriceInfoStack];
}

- (void)setupAssetNameLabel {
    _assetName = [[UILabel alloc]init];
    _assetName.translatesAutoresizingMaskIntoConstraints = NO;
    _assetName.font = [UIFont boldSystemFontOfSize: 16];
    _assetName.textColor = [UIColor blackColor];
    _assetName.numberOfLines = 0;
}

- (void)setupAssetAskPriceView {
    _assetAskPriceView = [[AssetPriceView alloc]initWithFlowType:AssetListFlow];
    _assetAskPriceView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupAssetBidPriceView {
    _assetBidPriceView = [[AssetPriceView alloc]initWithFlowType:AssetListFlow];
    _assetBidPriceView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupAssetInfoStack {
    _assetInfoStack = [[UIStackView alloc]init];
    _assetInfoStack.translatesAutoresizingMaskIntoConstraints = NO;
    _assetInfoStack.axis = UILayoutConstraintAxisHorizontal;
    _assetInfoStack.distribution = UIStackViewDistributionFill;
    _assetInfoStack.spacing = 10.0;
}

- (void)setupAssetInfoView {
    _assetInfoView = [[UIView alloc]init];
    _assetInfoStack.translatesAutoresizingMaskIntoConstraints = NO;
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

- (void)configureCell:(NSString *)model livePice: (AssetPriceModel *)price {
    
    _assetName.text = model;
    [_assetAskPriceView configureWithPrice: price.askPrice];
    [_assetBidPriceView configureWithPrice: price.bidPrice];
}

//- (void)configureCell:(AssetModel *)model livePice: (AssetPriceModel *)price {
//    _assetName.text = [[model.symbol stringByAppendingString:@" - "] stringByAppendingString: model.name ];
//    
//    [_assetAskPriceView configureWithPrice: price.askPrice];
//    [_assetBidPriceView configureWithPrice: price.bidPrice];
////    NSString *bidPriceString = [NSString stringWithFormat:@"%.2f", price.bidPrice.price];
////    NSString *askPriceString = [NSString stringWithFormat:@"%.2f", price.askPrice.price];
////    _assetBidPrice.text = [@"Bid Price : " stringByAppendingString: bidPriceString];
////    _assetAskPrice.text = [@"Ask Price : " stringByAppendingString: askPriceString];
////    _assetBidPrice.textColor = price.bidPrice.direction == AssetPriceChangeDirectionUp ? [UIColor greenColor] : [UIColor redColor];
////    _assetAskPrice.textColor = price.askPrice.direction == AssetPriceChangeDirectionUp ? [UIColor greenColor] : [UIColor redColor];
//}

@end
