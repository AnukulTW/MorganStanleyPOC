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
#import "TradeController.h"
#import <MorganStanleyTradingPOC-Swift.h>
@interface TradeViewController ()<UITableViewDataSource, SymbolsHandler>
//@property (nonatomic, nonnull, strong) SocketConnectionManager *socket;
@property (nonatomic, nonnull, strong) TradeController *controller;
@property (nonatomic, nonnull, strong) UITableView *instrumentList;
@property (nonatomic, nonnull, strong) NSArray *assetList;
@property (nonatomic, nonnull, strong) MarketAssetClient *assetClient;

@end

@implementation TradeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NetworkConnectionManager *manager = [[NetworkConnectionManager alloc] initWithAPIKey:Constants.apiKey apiSecret:Constants.apiSecret];
    _assetClient = [[MarketAssetClient alloc] initWithNetworkManager:manager];
    _assetClient.requiredSymbol = @[@"AMZN", @"AAPL",/*@"MLGO", @"INTC", @"AMTM", @"ARCA", @"ANAB", @"ABNB"*/];
    _controller = [[TradeController alloc]init];
    _controller.handler = self;
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
    
    NSString *model = _assetList[indexPath.row];
    AssetPriceModel *livePrice = [_controller fetchPrice: model];
    if (livePrice != NULL) {
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
//    __weak typeof(self) weakSelf = self;
//    [_assetClient fetchLastQuoteForAsset:@[@"AMZN", @"AAPL",@"MLGO", @"INTC", @"AMTM", @"ARCA", @"ANAB", @"ABNB"] completion:^(NSArray<AssetQuoteModel *> * _Nullable result, NSError * _Nullable error) {
//        [weakSelf updateAssetLatestQuoteAndRefreshUI: result];
//    }];
}

- (void)updateAssetLatestQuoteAndRefreshUI:(NSArray<AssetQuoteModel *> *)assetQuoteArray {
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^ {
            [weakSelf.controller.handler updateAssetLastQuote: assetQuoteArray];
            [weakSelf.instrumentList reloadData];
        });
    });
}

- (void)reloadWithAssetList:(NSArray *)newAssetList {
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^ {
            weakSelf.assetList = @[@"EURUSD", @"AUDUSD", @"USDJPY"]; //newAssetList;
            [weakSelf.instrumentList reloadData];
        });
    });
}

- (void)subscribeAssetLivePriceConnection:(NSArray<NSString *>*)assets {
    [_controller subscribeAssets: @[@"EURUSD", @"AUDUSD", @"USDJPY"]];
}

- (void)didReceivePrice:(AssetPriceModel *)priceModel forAsset:(NSString *)asset {

    dispatch_async(dispatch_get_main_queue(), ^{
        // Code here runs on the main thread
        // Safe to update UI
        [self updateUIForAsset:priceModel forAsset:asset];
    });
}


- (void)didReceivePrice:(NSDictionary <NSString* , AssetPriceModel*> *)messageDict {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateUIForAsset:messageDict];
    });

}

- (void)updateUIForAsset:(NSDictionary <NSString* , AssetPriceModel*> *)messageDict {
    
    NSArray<NSIndexPath *> *visibleIndexPaths = [self.instrumentList indexPathsForVisibleRows];

    
    NSMutableArray *indexPathToBeReloaded = [[NSMutableArray alloc]init];
    for (NSString *assetKey in [messageDict allKeys]) {
        for (NSIndexPath *indexPath in visibleIndexPaths) {
            AssetModel *assetAtIndex = _assetList[indexPath.row];
            if (assetAtIndex != NULL && [assetAtIndex.symbol isEqual: assetKey]) {
                // Then reload just that row
                [indexPathToBeReloaded addObject:indexPath];
            }
        }
    }
    
    [self.instrumentList reloadRowsAtIndexPaths: indexPathToBeReloaded withRowAnimation:UITableViewRowAnimationNone];

}


- (void)updateUIForAsset:(AssetPriceModel *)priceModel forAsset:(NSString *)asset {
    NSArray<NSIndexPath *> *visibleIndexPaths = [self.instrumentList indexPathsForVisibleRows];
    
    for (NSIndexPath *indexPath in visibleIndexPaths) {
        NSString *assetAtIndex = _assetList[indexPath.row];
        if (assetAtIndex != NULL && [assetAtIndex isEqual: asset]) {
            // Then reload just that row
            [self.instrumentList reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

@end


