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
    _priceLabel.font = [UIFont boldSystemFontOfSize: 16.0];
    _priceLabel.textColor = [UIColor blackColor];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
}

- (void)layoutContraints {
    [self addSubview: _priceLabel];
    [NSLayoutConstraint activateConstraints: @[
        [_priceLabel.leadingAnchor constraintEqualToAnchor: self.leadingAnchor],
        [_priceLabel.topAnchor constraintEqualToAnchor: self.topAnchor constant: 4.0],
        [_priceLabel.trailingAnchor constraintEqualToAnchor: self.trailingAnchor],
        [_priceLabel. bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant: -4.0]
    ]];
}

- (void)configureWithPrice: (PriceModel *)model {
    NSString *priceString = [NSString stringWithFormat:@"%.5f", model.price];
    _priceLabel.text = priceString;
    _priceLabel.textColor = model.direction == AssetPriceChangeDirectionUp ? [UIColor colorWithRed: 80.0/255 green: 107.0/255 blue: 94.0/255 alpha:1.0] : [UIColor whiteColor];
    
    
    self.backgroundColor = model.direction == AssetPriceChangeDirectionUp ? [UIColor colorWithRed: 160.0/255 green: 214.0/255 blue: 187.0/255 alpha:1.0] : [UIColor colorWithRed: 244.0/255 green: 55.0/255 blue: 66.0/255 alpha:1.0];
}

@end
