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

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *scrollContentView;

@end

@implementation MarketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupTopMovers];
    
    _client = [[MarketMovementAPIClient alloc]init];
    
    [_client fetchTopMarketMovers:^(NSMutableDictionary<NSString *,NSArray<MarketMoverModel *> *> * _Nullable marketMovers, NSError * _Nullable error) {
       
        
        [self displayTopThreeGainers: marketMovers];
        
    }];
    
    [self setupUIComponents];
    [self layoutContraints];
    
}

- (void)setupUIComponents {
    [self setupScrollView];
    [self setupScrollContentView];
}

- (void)setupScrollView {
    _scrollView = [[UIScrollView alloc]init];
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    _scrollView.backgroundColor = [UIColor grayColor];
}

- (void)setupScrollContentView {
    _scrollContentView = [[UIView alloc]init];
    _scrollContentView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layoutContraints {
    
    [self.view addSubview: _scrollView];
    [_scrollView addSubview: _scrollContentView];
    
    [_scrollContentView addSubview: _topMovers];
    
    [NSLayoutConstraint activateConstraints:@[
        [_scrollView.topAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.topAnchor],
        [_scrollView.bottomAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.bottomAnchor],
        [_scrollView.leadingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.leadingAnchor],
        [_scrollView.trailingAnchor constraintEqualToAnchor:self.view.safeAreaLayoutGuide.trailingAnchor],
    ]];
    
    // 4. Pin contentView to scrollView
    [NSLayoutConstraint activateConstraints:@[
        [_scrollContentView.topAnchor constraintEqualToAnchor:self.scrollView.topAnchor],
        [_scrollContentView.bottomAnchor constraintEqualToAnchor:self.scrollView.bottomAnchor],
        [_scrollContentView.leadingAnchor constraintEqualToAnchor:self.scrollView.leadingAnchor],
        [_scrollContentView.trailingAnchor constraintEqualToAnchor:self.scrollView.trailingAnchor],
        
        // Important: Set width equal to scrollView's width to enable vertical scrolling only
        [_scrollContentView.widthAnchor constraintEqualToAnchor:self.scrollView.widthAnchor],
    ]];
    
    [NSLayoutConstraint activateConstraints: @[
        [_topMovers.leadingAnchor constraintEqualToAnchor: _scrollContentView.leadingAnchor],
        [_topMovers.topAnchor constraintEqualToAnchor: _scrollContentView.topAnchor],
        [_topMovers.trailingAnchor constraintEqualToAnchor: _scrollContentView.trailingAnchor]
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
