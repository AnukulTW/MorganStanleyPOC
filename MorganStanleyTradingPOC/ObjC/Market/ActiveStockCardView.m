//
//  ActiveStockCardView.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import "ActiveStockCardView.h"


@interface ActiveStockCardView()
@property (nonatomic, nonnull ,strong) UILabel *symbolNameLabel;
@property (nonatomic, nonnull ,strong) UILabel *valueLabel;
@property (nonatomic, nonnull ,strong) UIStackView *symbolValueStackView;
@property (nonatomic, nonnull ,strong) UIStackView *contentStackView;
@end


@implementation ActiveStockCardView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIComponents];
        [self layoutContraints];
        self.backgroundColor = [UIColor colorWithRed:0.0/255 green:128.0/255 blue:0.0/255 alpha:1.0];
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
    [self setupValueLabel];
    [self setupContentStackView];
    [self setupSymbolValueStackView];
}

- (void)layoutContraints {
    
    [self addSubview:_contentStackView];
    
    [_contentStackView addArrangedSubview:_symbolValueStackView];
    
    [_symbolValueStackView addArrangedSubview:_symbolNameLabel];
    [_symbolValueStackView addArrangedSubview: _valueLabel];
    
    
    [NSLayoutConstraint activateConstraints: @[
        [_contentStackView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor
                                                        constant: 12.0],
        [_contentStackView.topAnchor constraintEqualToAnchor: self.topAnchor
                                                    constant: 12.0],
        [_contentStackView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor
                                                         constant: -12.0],
        [_contentStackView.bottomAnchor constraintEqualToAnchor: self.bottomAnchor
                                                       constant: -12.0],
    ]];
}


- (void)setupSymbolNameLabel {
    _symbolNameLabel = [[UILabel alloc]init];
    _symbolNameLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _symbolNameLabel.font = [UIFont boldSystemFontOfSize: 16.0];
    _symbolNameLabel.textColor = [UIColor whiteColor];
  
}

- (void)setupValueLabel {
    _valueLabel = [[UILabel alloc]init];
    _valueLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _valueLabel.font = [UIFont systemFontOfSize: 14.0];
    _valueLabel.textColor = [UIColor whiteColor];
}

- (void)setupContentStackView {
    _contentStackView = [[UIStackView alloc]init];
    _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentStackView.axis = UILayoutConstraintAxisHorizontal;
    _contentStackView.alignment = UIStackViewAlignmentFill;
    _contentStackView.distribution = UIStackViewDistributionFill;
    _contentStackView.spacing = 5.0;
}

- (void)setupSymbolValueStackView {
    _symbolValueStackView = [[UIStackView alloc]init];
    _symbolValueStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _symbolValueStackView.axis = UILayoutConstraintAxisVertical;
    _symbolValueStackView.alignment = UIStackViewAlignmentFill;
    _symbolValueStackView.distribution = UIStackViewDistributionFill;
    _symbolValueStackView.spacing = 5.0;
}

- (void)configureView:(ActiveStockModel *)model {
    _symbolNameLabel.text = model.assetName;
    _valueLabel.text = [NSString stringWithFormat:@"%.2lld", model.volume];
}

@end
