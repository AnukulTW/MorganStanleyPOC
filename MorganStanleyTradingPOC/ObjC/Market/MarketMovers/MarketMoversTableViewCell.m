//
//  MarketMoversTableViewCell.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 10/07/25.
//

#import "MarketMoversTableViewCell.h"
#import "MarketMoverCardView.h"

@interface MarketMoversTableViewCell()
@property (nonatomic, nonnull ,strong) MarketMoverCardView *marketMoverView;
@end

@implementation MarketMoversTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self setupUI];
        [self setupConstraints];
    }
    
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setupUI {
    _marketMoverView = [[MarketMoverCardView alloc]initWithFlowType: CellFlow];
    _marketMoverView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)setupConstraints {
    [self.contentView addSubview: _marketMoverView];
    [NSLayoutConstraint activateConstraints: @[
        [_marketMoverView.leadingAnchor constraintEqualToAnchor: self.contentView.leadingAnchor constant: 12.0],
        [_marketMoverView.topAnchor constraintEqualToAnchor: self.contentView.topAnchor constant: 6.0],
        [_marketMoverView.trailingAnchor constraintEqualToAnchor: self.contentView.trailingAnchor constant: -12.0],
        [_marketMoverView .bottomAnchor constraintEqualToAnchor: self.contentView.bottomAnchor constant: -6.0]
    ]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureWithMarketMover:(MarketMoverModel *)model {
    [_marketMoverView configureWithMarketMover: model];
}

@end
