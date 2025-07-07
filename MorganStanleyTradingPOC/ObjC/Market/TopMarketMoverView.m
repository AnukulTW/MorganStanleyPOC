//
//  TopMarketMoverView.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import "TopMarketMoverView.h"
#import "MarketMovementView.h"

@interface TopMarketMoverView()
@property (nonatomic, nonnull ,strong) UIStackView *contentStackView;
@property (nonatomic, assign) int counter;
@property (nonatomic, nonnull ,strong) UIStackView *marketMoverStackView;
@property (nonatomic, nonnull ,strong) UILabel *titleLabel;

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
    [self setupMarketMoverStackView];
}

- (void)setupContentStackView {
    _contentStackView = [[UIStackView alloc]init];
    _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentStackView.axis = UILayoutConstraintAxisVertical;
    _contentStackView.alignment = UIStackViewAlignmentFill;
    _contentStackView.distribution = UIStackViewDistributionFill;
    _contentStackView.spacing = 5.0;
}

- (void)setupMarketMoverStackView {
    _marketMoverStackView = [[UIStackView alloc]init];
    _marketMoverStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _marketMoverStackView.axis = UILayoutConstraintAxisHorizontal;
    _marketMoverStackView.alignment = UIStackViewAlignmentLeading;
    _marketMoverStackView.distribution = UIStackViewDistributionFillEqually;
    _marketMoverStackView.spacing = 5.0;
}
- (void)layoutContraints {
    
    [self addSubview: _contentStackView];
    [_contentStackView addArrangedSubview: _marketMoverStackView];
    
    [NSLayoutConstraint activateConstraints: @[
        [_contentStackView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 12.0],
        [_contentStackView.topAnchor constraintEqualToAnchor: self.topAnchor constant: 12.0],
        [_contentStackView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -12.0],
        [_contentStackView .bottomAnchor constraintEqualToAnchor: self.bottomAnchor],
    ]];
}

- (void)configureMarketMovers:(NSArray<MarketMoverModel *> *)marketMover {
    
    for (UIView *subview in _marketMoverStackView.arrangedSubviews) {
        [_marketMoverStackView removeArrangedSubview:subview];
        [subview removeFromSuperview];
    }
    
    for(int i=0; i<[marketMover count]; i ++) {
        MarketMovementView *view = [[MarketMovementView alloc]init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [_marketMoverStackView addArrangedSubview:view];
        [view configureWithMarketMover: marketMover[i]];
    }
}

@end

