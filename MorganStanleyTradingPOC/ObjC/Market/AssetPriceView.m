//
//  AssetPriceView.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 07/07/25.
//

#import "AssetPriceView.h"

@interface AssetPriceView()
@property (nonatomic, nonnull ,strong) UILabel *priceLabel;
@property (nonatomic, assign) AssetPriceViewFlowType flowType;
@end

@implementation AssetPriceView

- (instancetype)initWithFlowType:(AssetPriceViewFlowType)flowType {
    self = [super init];
    if (self) {
        _flowType = flowType;
        [self setupUIComponents];
        [self layoutContraints];
        self.layer.cornerRadius = 4.0;
        self.layer.borderWidth = 1.0;
        self.clipsToBounds = true;
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
        [_priceLabel.topAnchor constraintEqualToAnchor: self.topAnchor constant: 6.0],
        [_priceLabel.trailingAnchor constraintEqualToAnchor: self.trailingAnchor],
        [_priceLabel. bottomAnchor constraintEqualToAnchor: self.bottomAnchor constant: -6.0]
    ]];
}

- (void)configureWithPrice: (PriceModel *)model {
    NSString *priceString = [NSString stringWithFormat:@"%.5f", model.price];
    NSString *priceTypeString = model.priceType == AssetPriceTypeAsk ? @"Buy ": @"Sell ";
    if (_flowType == AssetDetailFlow) {
        priceString = [priceTypeString stringByAppendingString: priceString];
    }
    
    _priceLabel.text = priceString;
    
    
    if (model.direction == AssetPriceChangeDirectionNone) {
        _priceLabel.textColor = [UIColor blackColor];
        self.backgroundColor = [UIColor lightGrayColor];
        self.layer.borderColor = [UIColor blackColor].CGColor;
    } else {
        
        UIColor *upColor = [UIColor colorWithRed: 160.0/255 green: 214.0/255 blue: 187.0/255 alpha:1.0];
        UIColor *downColor = [UIColor colorWithRed: 244.0/255 green: 55.0/255 blue: 66.0/255 alpha:1.0];
        _priceLabel.textColor = model.direction == AssetPriceChangeDirectionUp ? [UIColor colorWithRed: 80.0/255 green: 107.0/255 blue: 94.0/255 alpha:1.0] : [UIColor whiteColor];
        self.backgroundColor = model.direction == AssetPriceChangeDirectionUp ? upColor : downColor;
        self.layer.borderColor = model.direction == AssetPriceChangeDirectionUp ? [UIColor greenColor].CGColor : [UIColor redColor].CGColor;
    }
}

@end
