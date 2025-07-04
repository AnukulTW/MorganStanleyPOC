//
//  MarketViewController.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import "MarketViewController.h"
#import "TopMarketMoverView.h"

@interface MarketViewController ()
@property (nonatomic, nonnull ,strong) TopMarketMoverView *topMovers;
@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTopMovers];
    
    [self.view addSubview:_topMovers];
    [NSLayoutConstraint activateConstraints: @[
        [_topMovers.leadingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.leadingAnchor
                                                 constant: 10],
        [_topMovers.topAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.topAnchor],
        [_topMovers.trailingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.trailingAnchor
                                                  constant: -10]
    ]];
}

- (void)setupTopMovers {
    _topMovers = [[TopMarketMoverView alloc]init];
    _topMovers.translatesAutoresizingMaskIntoConstraints = NO;
}

@end
