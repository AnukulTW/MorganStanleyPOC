//
//  MarketViewController.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import "MarketViewController.h"
#import "TopMarketMoverView.h"
#import "MarketMovementClient/MarketMovementAPIClient.h"

@interface MarketViewController ()<MarketMoverActionDelegate>
@property (nonatomic, nonnull ,strong) TopMarketMoverView *topMovers;
@property (nonatomic, nonnull ,strong) MarketMovementAPIClient *client;

@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTopMovers];
    
    _client = [[MarketMovementAPIClient alloc]init];
    
    [_client fetchTopMarketMovers:^(NSMutableDictionary<NSString *,NSArray<MarketMoverModel *> *> * _Nullable marketMovers, NSError * _Nullable error) {
       
        
        [self displayTopThreeGainers: marketMovers];
        
    }];
    
    [self.view addSubview:_topMovers];
    [NSLayoutConstraint activateConstraints: @[
        [_topMovers.leadingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.leadingAnchor
                                                 constant: 0],
        [_topMovers.topAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.topAnchor],
        [_topMovers.trailingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.trailingAnchor
                                                  constant: 0]
    ]];
}

- (void)setupTopMovers {
    _topMovers = [[TopMarketMoverView alloc]init];
    _topMovers.translatesAutoresizingMaskIntoConstraints = NO;
    _topMovers.marketMoverDelegate = self;
}

- (void)displayTopThreeGainers:(NSDictionary *)markerMovers {
    __weak typeof(self) weakSelf = self;
    
    NSArray *topGainers = markerMovers[@"gainers"];
    NSArray *topThreeGainers = [topGainers subarrayWithRange: NSMakeRange(0, 3)];
    
    NSArray *topLosers = markerMovers[@"losers"];
    NSArray *topThreeLosers = [topLosers subarrayWithRange: NSMakeRange(0, 3)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.topMovers configureMarketMovers:topThreeGainers
                                            topLosers:topThreeLosers];
        });
    });
}

- (void)viewAllMarketMovers { 
    
}

@end
