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
@end

@implementation TopMarketMoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIComponents];
        [self layoutContraints];
        [self setupMarketMovementViews];
    }
    
    return self;
}


- (void)setupUIComponents {
    [self setupContentStackView];
}

- (void)setupContentStackView {
    _contentStackView = [[UIStackView alloc]init];
    _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentStackView.axis = UILayoutConstraintAxisHorizontal;
    _contentStackView.alignment = UIStackViewAlignmentLeading;
    _contentStackView.distribution = UIStackViewDistributionFillEqually;
    _contentStackView.spacing = 5.0;
}

- (void)layoutContraints {
    
    [self addSubview:_contentStackView];
    
    [NSLayoutConstraint activateConstraints: @[
        [_contentStackView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor
                                                        constant: 10.0],
        [_contentStackView.topAnchor constraintEqualToAnchor: self.topAnchor constant: 12.0],
        [_contentStackView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor
                                                         constant: -10.0],
        [_contentStackView .bottomAnchor constraintEqualToAnchor: self.bottomAnchor],
    ]];
}

- (void)setupMarketMovementViews {
    for(int i =0; i<3; i ++) {
        MarketMovementView *view = [[MarketMovementView alloc]init];
        view.backgroundColor = [UIColor redColor];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [_contentStackView addArrangedSubview: view];
    }
}

@end
