//
//  TopMarketMoverView.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import "MarketMoverView.h"
#import "MarketMoverCardView.h"

@interface MarketMoverView()
@property (nonatomic, nonnull ,strong) UIStackView *contentStackView;
@property (nonatomic, nonnull ,strong) UIStackView *marketTopGainerContentStackView;
@property (nonatomic, nonnull ,strong) UIStackView *marketTopLoserContentStackView;
@property (nonatomic, nonnull ,strong) UIStackView *marketTopGainerStackView;
@property (nonatomic, nonnull ,strong) UIStackView *marketTopLoserStackView;
@property (nonatomic, nonnull ,strong) UILabel *topGainerLabel;
@property (nonatomic, nonnull ,strong) UILabel *topLosersLabel;
@property (nonatomic, nonnull ,strong) UIView *separatorView;
@property (nonatomic, nonnull ,strong) UIButton *viewAllMarketMoverButton;

@end

@implementation MarketMoverView

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
    [self setupViewAllMarketMoverButton];
    [self setupSeparatorView];
    [self setupContentStackView];
    [self setupTopGainerContentStackView];
    [self setupTopGainerStackView];
    [self setupTopGainerLabel];
    [self setupTopLoserContentStackView];
    [self setupTopLoserStackView];
    [self setupTopLoserLabel];
}

- (void)setupViewAllMarketMoverButton {
    _viewAllMarketMoverButton = [[UIButton alloc]init];
    _viewAllMarketMoverButton.translatesAutoresizingMaskIntoConstraints = NO;
    [_viewAllMarketMoverButton setTitle: @"View All Market Movers" forState: UIControlStateNormal];
    [_viewAllMarketMoverButton setTitleColor:[UIColor blueColor] forState: UIControlStateNormal];
}

- (void)setupTopGainerLabel {
    _topGainerLabel = [[UILabel alloc]init];
    _topGainerLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _topGainerLabel.text = @"Top Stock Gainer";
    _topGainerLabel.textColor = [UIColor blackColor];
    _topGainerLabel.font = [UIFont boldSystemFontOfSize: 16.0];
}

- (void)setupSeparatorView {
    _separatorView = [[UIView alloc]init];
    _separatorView.translatesAutoresizingMaskIntoConstraints = false;
    _separatorView.backgroundColor = [UIColor grayColor];
}

- (void)setupTopLoserLabel {
    _topLosersLabel = [[UILabel alloc]init];
    _topLosersLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _topLosersLabel.text = @"Top Stock Losers";
    _topLosersLabel.textColor = [UIColor blackColor];
    _topLosersLabel.font = [UIFont boldSystemFontOfSize: 16.0];
}

- (void)setupContentStackView {
    _contentStackView = [[UIStackView alloc]init];
    _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentStackView.axis = UILayoutConstraintAxisVertical;
    _contentStackView.alignment = UIStackViewAlignmentFill;
    _contentStackView.distribution = UIStackViewDistributionFill;
    _contentStackView.spacing = 20.0;
}

- (void)setupTopGainerContentStackView {
    _marketTopGainerContentStackView = [[UIStackView alloc]init];
    _marketTopGainerContentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _marketTopGainerContentStackView.axis = UILayoutConstraintAxisVertical;
    _marketTopGainerContentStackView.alignment = UIStackViewAlignmentFill;
    _marketTopGainerContentStackView.distribution = UIStackViewDistributionFill;
    _marketTopGainerContentStackView.spacing = 15.0;
}

- (void)setupTopLoserContentStackView {
    _marketTopLoserContentStackView = [[UIStackView alloc]init];
    _marketTopLoserContentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _marketTopLoserContentStackView.axis = UILayoutConstraintAxisVertical;
    _marketTopLoserContentStackView.alignment = UIStackViewAlignmentFill;
    _marketTopLoserContentStackView.distribution = UIStackViewDistributionFill;
    _marketTopLoserContentStackView.spacing = 15.0;
}

- (void)setupTopGainerStackView {
    _marketTopGainerStackView = [[UIStackView alloc]init];
    _marketTopGainerStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _marketTopGainerStackView.axis = UILayoutConstraintAxisHorizontal;
    _marketTopGainerStackView.alignment = UIStackViewAlignmentFill;
    _marketTopGainerStackView.distribution = UIStackViewDistributionFillEqually;
    _marketTopGainerStackView.spacing = 5.0;
}

- (void)setupTopLoserStackView {
    _marketTopLoserStackView = [[UIStackView alloc]init];
    _marketTopLoserStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _marketTopLoserStackView.axis = UILayoutConstraintAxisHorizontal;
    _marketTopLoserStackView.alignment = UIStackViewAlignmentFill;
    _marketTopLoserStackView.distribution = UIStackViewDistributionFillEqually;
    _marketTopLoserStackView.spacing = 5.0;
}

- (void)layoutContraints {
    
    [self addSubview: _contentStackView];
    [self addSubview: _separatorView];
    [self addSubview: _viewAllMarketMoverButton];
    
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
    ]];
    
    [NSLayoutConstraint activateConstraints: @[
        [_separatorView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor],
        [_separatorView.topAnchor constraintEqualToAnchor: _contentStackView.bottomAnchor
                                                    constant: 16.0],
        [_separatorView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor],
        [_separatorView.heightAnchor constraintEqualToConstant: 0.5]
    ]];
    
    [NSLayoutConstraint activateConstraints: @[
        [_viewAllMarketMoverButton.leadingAnchor constraintEqualToAnchor: self.leadingAnchor],
        [_viewAllMarketMoverButton.topAnchor constraintEqualToAnchor: _separatorView.bottomAnchor
                                                    constant: 14.0],
        [_viewAllMarketMoverButton.trailingAnchor constraintEqualToAnchor: self.trailingAnchor],
        [_viewAllMarketMoverButton.bottomAnchor constraintEqualToAnchor: self.bottomAnchor
                                                        constant: -8.0],
    ]];

}

- (void)configureMarketMovers:(NSArray<MarketMoverModel *> *)topGainers
                    topLosers:(NSArray<MarketMoverModel *> *) topLosers {
    
    [self layoutMarketMoverView: topGainers
                   forStackView: _marketTopGainerStackView
                    isTopGainer: true
    ];
    
    [self layoutMarketMoverView: topLosers
                   forStackView: _marketTopLoserStackView
                    isTopGainer: false
    ];
}

- (void)layoutMarketMoverView:(NSArray<MarketMoverModel *> *)marketMovers
                 forStackView: (UIStackView *) stackView
                  isTopGainer: (BOOL) isTopGainer {
    for (UIView *subview in stackView.arrangedSubviews) {
        if([subview isKindOfClass: MarketMoverCardView.self]) {
            [stackView removeArrangedSubview:subview];
            [subview removeFromSuperview];
        }
    }
    
    for(int i=0; i<[marketMovers count]; i ++) {
        MarketMoverCardView *view = [[MarketMoverCardView alloc]init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [stackView addArrangedSubview:view];
        [view configureWithMarketMover: marketMovers[i]
                       isTopGainerCard:isTopGainer];
    }
}

- (void)didTapViewAllMarketMovers {
    [self.marketMoverDelegate viewAllMarketMovers];
}

@end

