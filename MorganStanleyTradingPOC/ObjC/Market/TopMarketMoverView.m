//
//  TopMarketMoverView.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import "TopMarketMoverView.h"
#import "MarketMoverCardView.h"

@interface TopMarketMoverView()
@property (nonatomic, nonnull ,strong) UIStackView *contentStackView;
@property (nonatomic, nonnull ,strong) UIStackView *marketTopGainerContentStackView;
@property (nonatomic, nonnull ,strong) UIStackView *marketTopLoserContentStackView;
@property (nonatomic, nonnull ,strong) UIStackView *marketTopGainerStackView;
@property (nonatomic, nonnull ,strong) UIStackView *marketTopLoserStackView;
@property (nonatomic, nonnull ,strong) UILabel *topGainerLabel;
@property (nonatomic, nonnull ,strong) UILabel *topLosersLabel;

@end

@implementation TopMarketMoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIComponents];
        [self layoutContraints];
    }
    
    return self;
}


- (void)setupUIComponents {
    [self setupContentStackView];
    [self setupTopGainerContentStackView];
    [self setupTopGainerStackView];
    [self setupTopGainerLabel];
    [self setupTopLoserContentStackView];
    [self setupTopLoserStackView];
    [self setupTopLoserLabel];
}

- (void)setupTopGainerLabel {
    _topGainerLabel = [[UILabel alloc]init];
    _topGainerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _topGainerLabel.text = @"Top Market Gainer";
    _topGainerLabel.textColor = [UIColor blackColor];
}

- (void)setupTopLoserLabel {
    _topLosersLabel = [[UILabel alloc]init];
    _topLosersLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _topLosersLabel.text = @"Top Market Losers";
    _topLosersLabel.textColor = [UIColor blackColor];
}

- (void)setupContentStackView {
    _contentStackView = [[UIStackView alloc]init];
    _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentStackView.axis = UILayoutConstraintAxisVertical;
    _contentStackView.alignment = UIStackViewAlignmentFill;
    _contentStackView.distribution = UIStackViewDistributionFill;
    _contentStackView.spacing = 5.0;
}

- (void)setupTopGainerContentStackView {
    _marketTopGainerContentStackView = [[UIStackView alloc]init];
    _marketTopGainerContentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _marketTopGainerContentStackView.axis = UILayoutConstraintAxisVertical;
    _marketTopGainerContentStackView.alignment = UIStackViewAlignmentLeading;
    _marketTopGainerContentStackView.spacing = 5.0;
}

- (void)setupTopLoserContentStackView {
    _marketTopLoserContentStackView = [[UIStackView alloc]init];
    _marketTopLoserContentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _marketTopLoserContentStackView.axis = UILayoutConstraintAxisVertical;
    _marketTopLoserContentStackView.alignment = UIStackViewAlignmentLeading;
    _marketTopLoserContentStackView.spacing = 5.0;
}

- (void)setupTopGainerStackView {
    _marketTopGainerStackView = [[UIStackView alloc]init];
    _marketTopGainerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _marketTopGainerStackView.axis = UILayoutConstraintAxisHorizontal;
    _marketTopGainerStackView.alignment = UIStackViewAlignmentLeading;
    _marketTopGainerStackView.distribution = UIStackViewDistributionFillEqually;
    _marketTopGainerStackView.spacing = 5.0;
}

- (void)setupTopLoserStackView {
    _marketTopLoserStackView = [[UIStackView alloc]init];
    _marketTopLoserStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _marketTopLoserStackView.axis = UILayoutConstraintAxisHorizontal;
    _marketTopLoserStackView.alignment = UIStackViewAlignmentLeading;
    _marketTopLoserStackView.distribution = UIStackViewDistributionFillEqually;
    _marketTopLoserStackView.spacing = 5.0;
}

- (void)layoutContraints {
    
    [self addSubview: _contentStackView];
    [_contentStackView addArrangedSubview: _marketTopGainerContentStackView];
    [_contentStackView addArrangedSubview: _marketTopLoserContentStackView];

    [_marketTopGainerContentStackView addArrangedSubview: _topGainerLabel];
    [_marketTopLoserContentStackView addArrangedSubview: _topLosersLabel];
    
    [_marketTopGainerContentStackView addArrangedSubview: _marketTopGainerStackView];
    [_marketTopLoserContentStackView addArrangedSubview: _marketTopLoserStackView];
    
    [NSLayoutConstraint activateConstraints: @[
        [_contentStackView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 12.0],
        [_contentStackView.topAnchor constraintEqualToAnchor: self.topAnchor constant: 12.0],
        [_contentStackView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -12.0],
        [_contentStackView .bottomAnchor constraintEqualToAnchor: self.bottomAnchor],
    ]];
}

- (void)configureMarketMovers:(NSArray<MarketMoverModel *> *)topGainers
                    topLosers:(NSArray<MarketMoverModel *> *) topLosers {
    
    [self layoutMarketMoverView: topGainers
                   forStackView: _marketTopGainerStackView];
    
    [self layoutMarketMoverView: topLosers
                   forStackView: _marketTopLoserStackView];
}

- (void)layoutMarketMoverView:(NSArray<MarketMoverModel *> *)topGainers
                 forStackView: (UIStackView *) stackView{
    for (UIView *subview in stackView.arrangedSubviews) {
        if([subview isKindOfClass: MarketMoverCardView.self]) {
            [stackView removeArrangedSubview:subview];
            [subview removeFromSuperview];
        }
    }
    
    for(int i=0; i<[topGainers count]; i ++) {
        MarketMoverCardView *view = [[MarketMoverCardView alloc]init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [stackView addArrangedSubview:view];
        [view configureWithMarketMover: topGainers[i]];
    }
}

@end

