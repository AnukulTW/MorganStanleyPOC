//
//  MarketViewController.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 04/07/25.
//

#import "MarketViewController.h"
#import "MarketMoverView.h"
#import "ActiveStockView.h"
#import "MarketMovementClient/MarketMovementAPIClient.h"
#import "MarketMoversViewController.h"

@interface MarketViewController ()<MarketMoverActionDelegate>
@property (nonatomic, nonnull ,strong) MarketMoverView *marketMoverView;
@property (nonatomic, nonnull ,strong) ActiveStockView *stockView;
@property (nonatomic, nonnull ,strong) MarketMovementAPIClient *client;
//@property (nonatomic, strong) UIScrollView *scrollView;
//@property (nonatomic, strong) UIView *scrollContentView;
@property (nonatomic, strong) dispatch_queue_t networkOperationQueue;
@property (nonatomic, strong) MarketMovers *marketMovers;
@property (nonatomic, strong) UIStackView *contentStackView;

@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _networkOperationQueue = dispatch_queue_create("com.example.networkOperationQueue", DISPATCH_QUEUE_CONCURRENT);
    _client = [[MarketMovementAPIClient alloc]init];
    [self fetchData];
    [self setupUIComponents];
    [self layoutContraints];
}

- (void)setupUIComponents {
    [self setupTopMovers];
    [self setupActiveStock];
    [self setupContentStackView];
//    [self setupScrollView];
//    [self setupScrollContentView];
}

//- (void)setupScrollView {
//    _scrollView = [[UIScrollView alloc]init];
//    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
//    _scrollView.backgroundColor = [UIColor lightGrayColor];
//}
//
//- (void)setupScrollContentView {
//    _scrollContentView = [[UIView alloc]init];
//    _scrollContentView.translatesAutoresizingMaskIntoConstraints = NO;
//}

//- (void)layoutContraints {
//    
//    [self.view addSubview: _scrollView];
//    [_scrollView addSubview: _scrollContentView];
//    
//    [_scrollContentView addSubview: _marketMoverView];
//    [_scrollContentView addSubview: _stockView];
//    
//    [NSLayoutConstraint activateConstraints:@[
//        [_scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
//        [_scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
//        [_scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
//        [_scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
//    ]];
//    
//    // 4. Pin contentView to scrollView
//    [NSLayoutConstraint activateConstraints:@[
//        [_scrollContentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
//        [_scrollContentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
//        [_scrollContentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
//        [_scrollContentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
//        
//        // Important: Set width equal to scrollView's width to enable vertical scrolling only
//        [_scrollContentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor],
//    ]];
//    
//    [NSLayoutConstraint activateConstraints: @[
//        [_marketMoverView.leadingAnchor constraintEqualToAnchor: _scrollContentView.leadingAnchor],
//        [_marketMoverView.topAnchor constraintEqualToAnchor: _scrollContentView.topAnchor],
//        [_marketMoverView.trailingAnchor constraintEqualToAnchor: _scrollContentView.trailingAnchor]
//    ]];
//    
//    [NSLayoutConstraint activateConstraints: @[
//        [_stockView.leadingAnchor constraintEqualToAnchor: _scrollContentView.leadingAnchor],
//        [_stockView.topAnchor constraintEqualToAnchor: _marketMoverView.bottomAnchor constant: 20.0],
//        [_stockView.trailingAnchor constraintEqualToAnchor: _scrollContentView.trailingAnchor]
//    ]];
//    
//}


- (void)setupContentStackView {
    _contentStackView = [[UIStackView alloc]init];
    _contentStackView.translatesAutoresizingMaskIntoConstraints = NO;
    _contentStackView.axis = UILayoutConstraintAxisVertical;
    _contentStackView.distribution = UIStackViewDistributionEqualSpacing;
    _contentStackView.spacing = 20;
    _contentStackView.backgroundColor = [UIColor lightGrayColor];
}



- (void)layoutContraints {
    
    [self.view addSubview: _contentStackView];
    
    [_contentStackView addArrangedSubview: _marketMoverView];
    [_contentStackView addArrangedSubview: _stockView];
    
    [NSLayoutConstraint activateConstraints: @[
        [_contentStackView.leadingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.leadingAnchor],
        [_contentStackView.topAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.topAnchor],
        [_contentStackView.trailingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.trailingAnchor],
        [_contentStackView.bottomAnchor constraintLessThanOrEqualToAnchor: self.view.safeAreaLayoutGuide.bottomAnchor
                                                                 constant:0]
    ]];
    
}

- (void)setupTopMovers {
    _marketMoverView = [[MarketMoverView alloc]init];
    _marketMoverView.translatesAutoresizingMaskIntoConstraints = NO;
    _marketMoverView.marketMoverDelegate = self;
}

- (void)setupActiveStock {
    _stockView = [[ActiveStockView alloc]init];
    _stockView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)displayTopThreeGainers:(NSDictionary *)markerMovers {
    __weak typeof(self) weakSelf = self;
    
    NSArray *topGainers = markerMovers[@"gainers"];
    NSArray *topThreeGainers = [topGainers subarrayWithRange: NSMakeRange(0, 3)];
    
    NSArray *topLosers = markerMovers[@"losers"];
    NSArray *topThreeLosers = [topLosers subarrayWithRange: NSMakeRange(0, 3)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.marketMoverView configureMarketMovers:topThreeGainers
                                            topLosers:topThreeLosers];
        });
    });
}

- (void)displayTopThreeActiveStocks:(NSArray *)activeStocks {
    __weak typeof(self) weakSelf = self;
    
    NSArray *topThreeActiveStocks = [activeStocks subarrayWithRange: NSMakeRange(0, 3)];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.stockView configureStockView: topThreeActiveStocks];
        });
    });
}

- (void)viewAllMarketMovers {
    __weak typeof(self) weakSelf = self;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^ {
            MarketMoversViewController *vc = [[MarketMoversViewController alloc]initWithMarketGainer: weakSelf.marketMovers[@"gainers"]
                                                                                          withMarkketLoser: weakSelf.marketMovers[@"losers"]
            ];
            [weakSelf.navigationController pushViewController:vc animated: true];
        });
    });

}

- (void)fetchData {
    [self fetchActiveStocks];
    [self fetchMarketTopMovers];
}

- (void)fetchActiveStocks {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_networkOperationQueue, ^{
        [weakSelf.client fetchActiveStocks:^(NSArray<ActiveStockModel *> * _Nullable activeStocks, NSError * _Nullable error) {
            [self displayTopThreeActiveStocks: activeStocks];
        }];
    });
}

- (void)fetchMarketTopMovers {
    __weak typeof(self) weakSelf = self;
    dispatch_async(_networkOperationQueue, ^{
        [weakSelf.client fetchMarketTopMovers:^(NSMutableDictionary<NSString *,NSArray<MarketMoverModel *> *> * _Nullable marketMovers, NSError * _Nullable error) {
            weakSelf.marketMovers = marketMovers;
            [weakSelf displayTopThreeGainers: marketMovers];
        }];
    });
}


@end
