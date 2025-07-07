//
//  MarketMovementView.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import "MarketMovementCardView.h"

@interface MarketMovementCardView()
@property (nonatomic, nonnull ,strong) UILabel *symbolNameLabel;
@property (nonatomic, nonnull ,strong) UILabel *priceLabel;
@property (nonatomic, nonnull ,strong) UILabel *percentageChangeLabel;
@property (nonatomic, nonnull ,strong) UIStackView *contentStackView;
@end

@implementation MarketMovementCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIComponents];
        [self layoutContraints];
        self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    self.layer.cornerRadius = 10.0;
    self.layer.masksToBounds = YES;
}


- (void)setupUIComponents {
    [self setupSymbolNameLabel];
    [self setupPriceLabel];
    [self setupPercentageChangeLabel];
    [self setupContentStackView];
}

- (void)setupSymbolNameLabel {
    _symbolNameLabel = [[UILabel alloc]init];
    _symbolNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _symbolNameLabel.font = [UIFont boldSystemFontOfSize: 16.0];
    _symbolNameLabel.textColor = [UIColor whiteColor];
}

- (void)setupPriceLabel {
    _priceLabel = [[UILabel alloc]init];
    _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _priceLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    _priceLabel.textColor = [UIColor whiteColor];
}

- (void)setupPercentageChangeLabel {
    _percentageChangeLabel = [[UILabel alloc]init];
    _percentageChangeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _percentageChangeLabel.font = [UIFont systemFontOfSize: 13.0];
    _percentageChangeLabel.textColor = [UIColor whiteColor];
}

- (void)setupContentStackView {
    _contentStackView = [[UIStackView alloc]init];
    _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentStackView.axis = UILayoutConstraintAxisVertical;
    _contentStackView.distribution = UIStackViewDistributionEqualSpacing;
    _contentStackView.spacing = 2;
}


- (void)layoutContraints {
    [self addSubview: _contentStackView];
    
    [_contentStackView addArrangedSubview: _symbolNameLabel];
    [_contentStackView addArrangedSubview: _priceLabel];
    [_contentStackView addArrangedSubview: _percentageChangeLabel];
    
    [NSLayoutConstraint activateConstraints: @[
        [_contentStackView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor
                                                        constant: 10.0],
        [_contentStackView.topAnchor constraintEqualToAnchor: self.topAnchor
                                                    constant: 8.0],
        [_contentStackView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor
                                                         constant: -10.0],
        [_contentStackView .bottomAnchor constraintEqualToAnchor: self.bottomAnchor
                                                        constant: -8.0],
    ]];
}

- (void)configureWithMarketMover:(MarketMoverModel *)model {
    _symbolNameLabel.text = model.assetName;
    _priceLabel.text = [NSString stringWithFormat:@"%.2f", model.price];
    NSString *percentageChangeString = [[NSString stringWithFormat:@"%.2f", model.percent_change] stringByAppendingFormat: @"%%"];
    
    NSString *bracketPercentageString = [NSString stringWithFormat:@"(%@)", percentageChangeString];
    NSString *valueChangeString = [NSString stringWithFormat:@"%.2f", model.change];
    _percentageChangeLabel.text = [[valueChangeString stringByAppendingString: @" "] stringByAppendingString: bracketPercentageString];
}

@end
