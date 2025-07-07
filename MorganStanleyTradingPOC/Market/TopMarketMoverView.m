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
@property (nonatomic, nonnull ,strong) UIView *containerView;

@end

@implementation TopMarketMoverView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupContentStackView];
        [self layoutContraints];
        [self setupMarketMovementViews];
    }
    
    return self;
}


- (void)setupUIComponents {
    [self setupContentContainerView];
}

- (void)setupContentStackView {
    _contentStackView = [[UIStackView alloc]init];
    _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentStackView.axis = UILayoutConstraintAxisVertical;
    _contentStackView.alignment = UIStackViewAlignmentFill;
    _contentStackView.distribution = UIStackViewDistributionFill;
    _contentStackView.spacing = 5.0;
}

- (void)setupContentContainerView {
    _containerView = [[UIView alloc]init];
    //_containerView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layoutContraints {
    
    [self addSubview: _contentStackView];
    
    [NSLayoutConstraint activateConstraints: @[
        [_contentStackView.leadingAnchor constraintEqualToAnchor: self.leadingAnchor constant: 12.0],
        [_contentStackView.topAnchor constraintEqualToAnchor: self.topAnchor constant: 12.0],
        [_contentStackView.trailingAnchor constraintEqualToAnchor: self.trailingAnchor constant: -12.0],
        [_contentStackView .bottomAnchor constraintEqualToAnchor: self.bottomAnchor],
    ]];
}

- (void)setupMarketMovementViews {
    NSUInteger interSpacing = 5;
    NSUInteger leadingSpacing = 10;
    NSUInteger trailingSpacing = 10;
    NSUInteger itemRowSpacing = 10;
    NSUInteger itemHeight = 80;
    
    
    NSMutableArray *contentViewArray = [[NSMutableArray alloc]init];
    for(int i =0; i<6; i ++) {
        MarketMovementView *view = [[MarketMovementView alloc]init];
        view.translatesAutoresizingMaskIntoConstraints = NO;
        [contentViewArray addObject: view];
        
        if((i % 3 == 2 && i > 0) || i == 5) {
            UIStackView *stackView = [self createNewHStackView];
            [contentViewArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [stackView addArrangedSubview: obj];
            }];
            
            [_contentStackView addArrangedSubview: stackView];
            [contentViewArray removeAllObjects];
        }
    }
    
    
//    for(int i =0; i<5; i ++) {
//        CGRect screenRect = [[UIScreen mainScreen] bounds];
//        NSUInteger availableWidth = (screenRect.size.width) - leadingSpacing - trailingSpacing - (2 * interSpacing);
//        NSUInteger itemWidth = availableWidth / 3;
//        NSUInteger x = leadingSpacing + ((interSpacing + itemWidth) * (i % 3));
//        NSUInteger y = (itemHeight * (i / 3)) + (itemRowSpacing * (i/3));
//        
//        CGRect frame = CGRectMake(x, y, itemWidth , itemHeight);
//        
//        MarketMovementView *view = [[MarketMovementView alloc]initWithFrame: frame];
//        view.backgroundColor = [UIColor redColor];
//        //view.translatesAutoresizingMaskIntoConstraints = NO;
//        [_containerView addSubview: view];
//    }
}

- (UIStackView *)createNewHStackView {
    UIStackView *stackView = [[UIStackView alloc]init];
    stackView.translatesAutoresizingMaskIntoConstraints = NO;
    stackView.axis = UILayoutConstraintAxisHorizontal;
    stackView.alignment = UIStackViewAlignmentLeading;
    stackView.distribution = UIStackViewDistributionFillEqually;
    stackView.spacing = 5.0;

    return stackView;
}

@end
