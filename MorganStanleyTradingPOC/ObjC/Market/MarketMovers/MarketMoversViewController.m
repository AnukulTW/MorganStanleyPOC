//
//  MarketTopMoversViewController.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 09/07/25.
//

#import "MarketMoversViewController.h"
#import "MarketMoversTableViewCell.h"

typedef NS_ENUM(NSInteger, MarketTopMover) {
    MarketTopMoverGainers = 0,
    MarketTopMoverLosers = 1,
};


@interface MarketMoversViewController ()<UITableViewDataSource>
@property (nonatomic, strong) UISegmentedControl *segmentControl;
@property (nonatomic, nonnull, strong) UITableView *marketMoverTableView;
@property (nonatomic, nonnull, strong) NSArray<MarketMoverModel *> *marketGainers;
@property (nonatomic, nonnull, strong) NSArray<MarketMoverModel *> *marketLosers;
@property (nonatomic, nonnull, strong) NSArray<MarketMoverModel *> *dataSource;
@end

@implementation MarketMoversViewController

- (instancetype)initWithMarketGainer:(NSArray<MarketMoverModel *> *)marketGainer
                    withMarkketLoser:(NSArray<MarketMoverModel *> *)marketLosers  {
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        _marketGainers = marketGainer;
        _marketLosers = marketLosers;
        _dataSource = _marketGainers;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupUIComponents];
    [self layoutContraints];
}

- (void)setupUIComponents {
    [self setupSegmentControl];
    [self setupMarketMoverTableViewTableView];
}

- (void)setupMarketMoverTableViewTableView {
    _marketMoverTableView = [[UITableView alloc]init];
    _marketMoverTableView.translatesAutoresizingMaskIntoConstraints = NO;
    _marketMoverTableView.dataSource = self;
    [_marketMoverTableView registerClass: [MarketMoversTableViewCell self]
            forCellReuseIdentifier: @"MarketMoversTableViewCell"];
}

- (void)setupSegmentControl {
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Top Gainers", @"Top Losers"]];
    _segmentControl.translatesAutoresizingMaskIntoConstraints = NO;
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl addTarget:self
                        action:@selector(segmentChanged:)
              forControlEvents:UIControlEventValueChanged
    ];
}

- (void)layoutContraints {
    [self layoutSegmentControlViewConstraints];
    [self layoutMarketMoverTableViewConstraints];
}

- (void)layoutSegmentControlViewConstraints {
    [self.view addSubview: _segmentControl];
    [NSLayoutConstraint activateConstraints: @[
        [_segmentControl.topAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.topAnchor],
        [_segmentControl.leadingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.leadingAnchor
                                                      constant: 40.0],
        [_segmentControl.trailingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.trailingAnchor
                                                       constant: -40.0],
        [_segmentControl.heightAnchor constraintEqualToConstant: 35.0],
    ]];
}

- (void)layoutMarketMoverTableViewConstraints {
    [self.view addSubview:_marketMoverTableView];
    [NSLayoutConstraint activateConstraints: @[
        [_marketMoverTableView.topAnchor constraintEqualToAnchor: _segmentControl.bottomAnchor constant: 20.0],
        [_marketMoverTableView.leadingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.leadingAnchor],
        [_marketMoverTableView.trailingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.trailingAnchor],
        [_marketMoverTableView.bottomAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.bottomAnchor],
    ]];
}

- (void)segmentChanged:(UISegmentedControl *)segment {
    NSUInteger selectedIndex = segment.selectedSegmentIndex;
    if(selectedIndex == 0) {
        _dataSource = _marketGainers;
    } else {
        _dataSource = _marketLosers;
    }
    
    __weak typeof(self) weakSelf = self;

    [UIView animateWithDuration: 0.1 animations:^{
        [weakSelf.marketMoverTableView reloadData];
    }];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    MarketMoversTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"MarketMoversTableViewCell"
                                                                      forIndexPath:indexPath];
    MarketMoverModel *model = _dataSource[indexPath.row];
    [cell configureWithMarketMover: model];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}


@end
