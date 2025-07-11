//
//  MarketMovementView.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import "MarketMoverCardView.h"

@interface MarketMoverCardView()
@property (nonatomic, nonnull ,strong) UILabel *symbolNameLabel;
@property (nonatomic, nonnull ,strong) UILabel *priceLabel;
@property (nonatomic, nonnull ,strong) UILabel *percentageChangeLabel;
@property (nonatomic, nonnull ,strong) UIStackView *contentStackView;
@property (nonatomic, assign) MarketMoverCardViewFlowType flowType;
@property (nonatomic, nonnull, strong) UIColor *textColor;

@end

@implementation MarketMoverCardView


- (instancetype)initWithFlowType:(MarketMoverCardViewFlowType)flowType {
    self = [super init];
    if (self) {
        _flowType = flowType;
        _textColor = _flowType == CardFlow ? [UIColor whiteColor] : [UIColor blackColor];
        [self setupUIComponents];
        [self layoutContraints];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    if(_flowType == CardFlow) {
        self.layer.cornerRadius = 10.0;
        self.layer.masksToBounds = YES;
    }
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
    _symbolNameLabel.textColor = _textColor;
}

- (void)setupPriceLabel {
    _priceLabel = [[UILabel alloc]init];
    _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _priceLabel.font = [UIFont boldSystemFontOfSize: 14.0];
    _priceLabel.textColor = _textColor;
}

- (void)setupPercentageChangeLabel {
    _percentageChangeLabel = [[UILabel alloc]init];
    _percentageChangeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _percentageChangeLabel.font = [UIFont systemFontOfSize: 13.0];
    _percentageChangeLabel.textColor = _textColor;
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
        [_contentStackView.bottomAnchor constraintEqualToAnchor: self.bottomAnchor
                                                       constant: -8.0]
    ]];
    
}

- (void)configureWithMarketMover:(MarketMoverModel *)model isTopGainerCard: (BOOL) isTopGainerCard {

    [self configureWithMarketMover: model];
    
    self.backgroundColor = isTopGainerCard ? [UIColor colorWithRed:0.0/255 green:128.0/255 blue:0.0/255 alpha:1.0] :
        [UIColor colorWithRed:205.0/255 green: 28.0/255 blue: 24.0/255 alpha:1.0];
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
