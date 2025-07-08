//
//  ViewController.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "TradeViewController.h"
//#import "SocketConnectionManager.h"
#import "NativeSocketConnectionManager.h"
#import "NetworkConnectionManager.h"
#import "AssetModel.h"
#import "AssetQuoteModel.h"
#import "AssetTableViewCell.h"
#import "MarketAssetClient.h"
#import <MorganStanleyTradingPOC-Swift.h>
@interface TradeViewController ()<UITableViewDataSource, NativeSocketConnectionManagerDelegate>
//@property (nonatomic, nonnull, strong) SocketConnectionManager *socket;
@property (nonatomic, nonnull, strong) NativeSocketConnectionManager *socket;
@property (nonatomic, nonnull, strong) UITableView *instrumentList;
@property (nonatomic, nonnull, strong) NSArray *assetList;
@property (nonatomic, nonnull, strong) MarketAssetClient *assetClient;
@property (nonatomic, nonnull, strong) UIActivityIndicatorView *activityView;

@end

@implementation TradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _socket = [[NativeSocketConnectionManager alloc]init];
    _socket.connectionDelegate = self;
    NetworkConnectionManager *manager = [[NetworkConnectionManager alloc] initWithAPIKey:Constants.apiKey apiSecret:Constants.apiSecret];
    _assetClient = [[MarketAssetClient alloc] initWithNetworkManager:manager];
    _assetClient.requiredSymbol = @[@"AMZN", @"AAPL",/*@"MLGO", @"INTC", @"AMTM", @"ARCA", @"ANAB", @"ABNB"*/];
    _assetList = @[@"EURUSD", @"AUDUSD", @"USDJPY", @"USDCAD", @"GBPUSD", @"EURGBP", @"AUDCAD", @"USDHKD"];
    //@[@"AMZN", @"AAPL",@"MLGO", @"INTC", @"AMTM", @"ARCA", @"ANAB", @"ABNB"]
    
    [self openSocketConnection];
    [self setupUIComponents];
    [self layoutContraints];
}

- (void)layoutContraints {
    [self layoutInstrumentListConstraints];
}

- (void)layoutInstrumentListConstraints {
    [self.view addSubview:_instrumentList];
    [NSLayoutConstraint activateConstraints: @[
        [_instrumentList.topAnchor constraintEqualToAnchor: self.view.topAnchor],
        [_instrumentList.leadingAnchor constraintEqualToAnchor: self.view.leadingAnchor],
        [_instrumentList.trailingAnchor constraintEqualToAnchor: self.view.trailingAnchor],
        [_instrumentList.bottomAnchor constraintEqualToAnchor: self.view.bottomAnchor],
    ]];
}


- (void)setupUIComponents {
    [self setupTableView];
}

- (void)openSocketConnection {
    _instrumentList.hidden = true;
    [self showActivityIndicatorView];
    [_socket openSocketConnection];
}

- (void)setupTableView {
    _instrumentList = [[UITableView alloc]init];
    _instrumentList.translatesAutoresizingMaskIntoConstraints = NO;
    _instrumentList.dataSource = self;
    [_instrumentList registerClass: [AssetTableViewCell self]
            forCellReuseIdentifier: @"AssetTableViewCell"];
    _instrumentList.hidden = true;
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AssetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"AssetTableViewCell"
                                                               forIndexPath:indexPath];
    
    NSString *model = _assetList[indexPath.row];
    if ([_socket fetchPrice: model] != NULL) {
        AssetPriceModel *livePrice = [_socket fetchPrice: model];
        [cell configureCell: model livePice: livePrice];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _assetList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (void)fetchAsset {
    __weak typeof(self) weakSelf = self;
    [_assetClient fetchMarketAssetWithCompletion:^(NSArray<AssetQuoteModel *> * _Nullable result, NSArray<NSString *> * _Nullable list, NSError * _Nullable error) {
            [weakSelf reloadWithAssetList:result];
            [weakSelf subscribeAssetLivePriceConnection:list];
    }];
}

- (void)fetchLastQuotes {
    
    __weak typeof(self) weakSelf = self;
    [_assetClient fetchLastQuoteForAsset: _assetList
                              completion:^(NSArray<AssetQuoteModel *> * _Nullable result, NSError * _Nullable error) {
        [weakSelf updateAssetLatestQuoteAndRefreshUI: result];
        [weakSelf subscribeAssetLivePriceConnection: weakSelf.assetList];
    }];
}

- (void)updateAssetLatestQuoteAndRefreshUI:(NSArray<AssetQuoteModel *> *)assetQuoteArray {
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.socket updateAssetLastQuote: assetQuoteArray];
            [weakSelf hideActivityIndicatorView];
            weakSelf.instrumentList.hidden = false;
            [weakSelf.instrumentList reloadData];
        });
    });
}

- (void)reloadWithAssetList:(NSArray *)newAssetList {
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^ {
            //weakSelf.assetList = @[@"EURUSD", @"AUDUSD", @"USDJPY"]; //newAssetList;
            [weakSelf.instrumentList reloadData];
        });
    });
}

- (void)subscribeAssetLivePriceConnection:(NSArray<NSString *>*)assets {
    [_socket subscribeAssets: _assetList];
}

- (void)didReceivePrice:(AssetPriceModel *)priceModel forAsset:(NSString *)asset {

    dispatch_async(dispatch_get_main_queue(), ^{
        // Code here runs on the main thread
        // Safe to update UI
        [self updateUIForAsset:priceModel forAsset:asset];
    });
}

- (void)connectionEstablishSuccess {
    [self fetchLastQuotes];
}

- (void)updateUIForAsset:(AssetPriceModel *)priceModel forAsset:(NSString *)asset {
    NSArray<NSIndexPath *> *visibleIndexPaths = [self.instrumentList indexPathsForVisibleRows];
    
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        NSString *assetAtIndex = _assetList[indexPath.row];
        if (assetAtIndex != NULL && [assetAtIndex isEqual: asset]) {
            AssetTableViewCell *cell = [_instrumentList cellForRowAtIndexPath:indexPath];
            [cell configureCell:asset livePice: priceModel];
        }
    }
}


- (void)showActivityIndicatorView {
    _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleMedium];
    _activityView.color = [UIColor grayColor];
    _activityView.center = self.view.center;
    [self.view addSubview: _activityView];
    _activityView.hidesWhenStopped = YES;
    [_activityView startAnimating];
}

- (void)hideActivityIndicatorView {
    [_activityView stopAnimating];
    [_activityView removeFromSuperview];
}

@end


