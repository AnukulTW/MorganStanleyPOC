//
//  ActiveStockView.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import "ActiveStockView.h"
#import "ActiveStockCardView.h"

@interface ActiveStockView()
@property (nonatomic, nonnull ,strong) UIStackView *contentStackView;
@property (nonatomic, nonnull ,strong) UILabel *titleLabel;
@property (nonatomic, nonnull ,strong) UILabel *subTitleLabel;
@end

@implementation ActiveStockView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIComponents];
        [self layoutContraints];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void)setupUIComponents {
    [self setupContentStackView];
    [self setupTitleLabel];
    [self setupSubtitleLabel];
}

- (void)layoutContraints {
    
    [self addSubview:_contentStackView];
    [self addSubview: _titleLabel];
    [self addSubview: _subTitleLabel];
    
    [NSLayoutConstraint activateConstraints: @[
        [_titleLabel.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 12.0],
        [_titleLabel.topAnchor constraintEqualToAnchor: self.topAnchor constant: 12.0],
        [_titleLabel.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -12.0],
    ]];
    
    [NSLayoutConstraint activateConstraints: @[
        [_subTitleLabel.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 12.0],
        [_subTitleLabel.topAnchor constraintEqualToAnchor: _titleLabel.bottomAnchor constant: 2.0],
        [_subTitleLabel.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -12.0],
    ]];
    
    [NSLayoutConstraint activateConstraints: @[
        [_contentStackView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 12.0],
        [_contentStackView.topAnchor constraintEqualToAnchor: _subTitleLabel.bottomAnchor constant: 12.0],
        [_contentStackView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -12.0],
        [_contentStackView.bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant: -12.0],
    ]];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.text = @"Most Active Stocks";
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize: 16.0];
}

- (void)setupSubtitleLabel {
    _subTitleLabel = [[UILabel alloc]init];
    _subTitleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _subTitleLabel.text = @"(Based on total volume)";
    _subTitleLabel.textColor = [UIColor blackColor];
    _subTitleLabel.font = [UIFont systemFontOfSize: 10.0];
}

- (void)setupContentStackView {
    _contentStackView = [[UIStackView alloc]init];
    _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentStackView.axis = UILayoutConstraintAxisHorizontal;
    _contentStackView.alignment = UIStackViewAlignmentLeading;
    _contentStackView.distribution = UIStackViewDistributionFillEqually;
    _contentStackView.spacing = 5.0;
}

- (void)configureStockView:(NSArray<ActiveStockModel *> *)activeStocks {
    for (int i = 0; i < [activeStocks count]; i++) {
        ActiveStockCardView *view = [[ActiveStockCardView alloc]init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [view configureView: activeStocks[i]];
        [_contentStackView addArrangedSubview:view];
    }
}

@end
