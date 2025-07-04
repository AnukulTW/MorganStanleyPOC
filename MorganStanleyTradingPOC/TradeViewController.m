//
//  ViewController.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "TradeViewController.h"
#import "SocketConnectionManager.h"
#import "NetworkConnectionManager.h"
#import "Model/AssetModel.h"
#import "Model/AssetQuoteModel.h"
#import "AssetTableViewCell.h"
#import "MarketAssetClient.h"
#import <MorganStanleyTradingPOC-Swift.h>
@interface TradeViewController ()<UITableViewDataSource, SocketConnectionManagerDelegate>
@property (nonatomic, nonnull, strong) SocketConnectionManager *socket;
@property (nonatomic, nonnull, strong) UITableView *instrumentList;
@property (nonatomic, nonnull, strong) NSArray *assetList;
@property (nonatomic, nonnull, strong) MarketAssetClient *assetClient;

@end

@implementation TradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _socket = [[SocketConnectionManager alloc]init];
    _socket.connectionDelegate = self;
    NetworkConnectionManager *manager = [[NetworkConnectionManager alloc] initWithAPIKey:Constants.apiKey apiSecret:Constants.apiSecret];
    _assetClient = [[MarketAssetClient alloc] initWithNetworkManager:manager];
    _assetClient.requiredSymbol = @[@"AMZN", @"AAPL",@"MLGO", @"INTC", @"AMTM", @"ARCA", @"ANAB", @"ABNB"];
    [self fetchLastQuotes];
    [self setupUIComponents];
    [self layoutContraints];
    [self fetchAsset];
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

- (void)setupTableView {
    _instrumentList = [[UITableView alloc]init];
    _instrumentList.translatesAutoresizingMaskIntoConstraints = NO;
    _instrumentList.dataSource = self;
    [_instrumentList registerClass: [AssetTableViewCell self]
            forCellReuseIdentifier: @"AssetTableViewCell"];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    AssetTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"AssetTableViewCell"
                                                               forIndexPath:indexPath];
    
    AssetModel *model = _assetList[indexPath.row];
    NSString *livePrice = [_socket fetchPrice: model.symbol];
    [cell configureCell: model livePice: livePrice];
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
    [_assetClient fetchLastQuoteForAsset:@[@"AMZN", @"AAPL",@"MLGO", @"INTC", @"AMTM", @"ARCA", @"ANAB", @"ABNB"] completion:^(NSArray<AssetQuoteModel *> * _Nullable result, NSError * _Nullable error) {
        [weakSelf updateAssetLatestQuoteAndRefreshUI: result];
    }];
}

- (void)updateAssetLatestQuoteAndRefreshUI:(NSArray<AssetQuoteModel *> *)assetQuoteArray {
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.socket updateAssetLastQuote: assetQuoteArray];
            [weakSelf.instrumentList reloadData];
        });
    });
}

- (void)reloadWithAssetList:(NSArray *)newAssetList {
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^ {
            weakSelf.assetList = newAssetList;
            [weakSelf.instrumentList reloadData];
        });
    });
}

- (void)subscribeAssetLivePriceConnection:(NSArray<NSString *>*)assets {
    [_socket subscribeAssets:assets];
}

- (void)didReceivePrice:(NSString *)price forAsset:(NSString *)asset {
    dispatch_async(dispatch_get_main_queue(), ^{
        // Code here runs on the main thread
        // Safe to update UI
        [self updateUIForAsset:asset withPrice:price];
    });
}

- (void)updateUIForAsset:(NSString *)asset withPrice:(NSString *)price {
    NSArray<NSIndexPath *> *visibleIndexPaths = [self.instrumentList indexPathsForVisibleRows];
    
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        AssetModel *assetAtIndex = _assetList[indexPath.row];
        if (assetAtIndex != NULL && [assetAtIndex.symbol isEqual: asset]) {
            // Then reload just that row
            [self.instrumentList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

@end
