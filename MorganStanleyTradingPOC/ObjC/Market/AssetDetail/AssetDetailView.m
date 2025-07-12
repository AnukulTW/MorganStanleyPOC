//
//  AssetDetailView.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 11/07/25.
//

#import "AssetDetailView.h"

@interface AssetDetailView()
@property (nonatomic, nonnull ,strong) UIStackView *assetPriceInfoStack;
@property (nonatomic, nonnull ,strong) AssetPriceView *assetBidPriceView;
@property (nonatomic, nonnull ,strong) AssetPriceView *assetAskPriceView;
@end

@implementation AssetDetailView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIComponents];
        [self layoutContraints];
    }
    
    return self;
}

- (void)setupUIComponents {
    [self setupAssetAskPriceView];
    [self setupAssetBidPriceView];
    [self setupAssetPriceInfoStack];
}

- (void)setupAssetAskPriceView {
    _assetAskPriceView = [[AssetPriceView alloc]initWithFlowType: AssetDetailFlow];
    _assetAskPriceView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupAssetBidPriceView {
    _assetBidPriceView = [[AssetPriceView alloc]initWithFlowType: AssetDetailFlow];
    _assetBidPriceView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupAssetPriceInfoStack {
    _assetPriceInfoStack = [[UIStackView alloc]init];
    _assetPriceInfoStack.translatesAutoresizingMaskIntoConstraints = NO;
    _assetPriceInfoStack.axis = UILayoutConstraintAxisHorizontal;
    _assetPriceInfoStack.distribution = UIStackViewDistributionFillEqually;
    _assetPriceInfoStack.spacing = 4.0;
}

- (void)layoutContraints {
    
    [self addSubview: _assetPriceInfoStack];
    
    [_assetPriceInfoStack addArrangedSubview: _assetAskPriceView];
    [_assetPriceInfoStack addArrangedSubview: _assetBidPriceView];
    
    [NSLayoutConstraint activateConstraints: @[
        [_assetPriceInfoStack.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 10],
        [_assetPriceInfoStack.topAnchor constraintEqualToAnchor: self.topAnchor constant: 12.0],
        [_assetPriceInfoStack.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -10],
        [_assetPriceInfoStack .bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant: -12.0],
    ]];
}

- (void)configureWithPrice: (AssetPriceModel *)model {
    [_assetBidPriceView configureWithPrice:model.bidPrice];
    [_assetAskPriceView configureWithPrice:model.askPrice];
}

@end
