//
//  AssetPriceView.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import "AssetPriceView.h"

@interface AssetPriceView()
@property (nonatomic, nonnull ,strong) UILabel *priceLabel;

@end

@implementation AssetPriceView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUIComponents];
        [self layoutContraints];
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

- (void) setupUIComponents {
    [self setupPriceLabelLabel];
}

- (void)setupPriceLabelLabel {
    _priceLabel = [[UILabel alloc]init];
    _priceLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _priceLabel.font = [UIFont systemFontOfSize: 14.0];
    _priceLabel.textColor = [UIColor blackColor];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutContraints {
    [self addSubview: _priceLabel];
    [NSLayoutConstraint activateConstraints: @[
        [_priceLabel.leadingAnchor constraintEqualToAnchor: self.leadingAnchor],
        [_priceLabel.topAnchor constraintEqualToAnchor: self.topAnchor],
        [_priceLabel.trailingAnchor constraintEqualToAnchor: self.trailingAnchor],
        [_priceLabel. bottomAnchor constraintEqualToAnchor: self.bottomAnchor]
    ]];
}

- (void)configureWithPrice: (PriceModel *)model {
    NSString *priceString = [NSString stringWithFormat:@"%.5f", model.price];
    _priceLabel.text = priceString;
    _priceLabel.textColor = [UIColor whiteColor];
    self.backgroundColor = model.direction == AssetPriceChangeDirectionUp ? [UIColor greenColor] : [UIColor redColor];
}

@end
