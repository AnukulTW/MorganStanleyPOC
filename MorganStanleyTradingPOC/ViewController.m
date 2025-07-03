//
//  ViewController.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "ViewController.h"
#import "SocketConnectionManager.h"
#import "NetworkConnectionManager.h"
#import "Model/AssetModel.h"
#import "AssetTableViewCell.h"

@interface ViewController ()<UITableViewDataSource, SocketConnectionManagerDelegate>
@property (nonatomic, nonnull, strong) SocketConnectionManager *socket;
@property (nonatomic, nonnull, strong) UITableView *instrumentList;
@property (nonatomic, nonnull, strong) NSArray *assetList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _socket = [[SocketConnectionManager alloc]init];
    _socket.connectionDelegate = self;
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
    
    NetworkConnectionManager *connection = [[NetworkConnectionManager alloc]init];
    __weak typeof(self) weakSelf = self;
    
    [connection fetchData:^(NSData * _Nullable data, NSError * _Nullable error) {
        
        if(data != NULL) {
            NSError *decodingError;
            NSArray *responseArray = [NSJSONSerialization JSONObjectWithData:data
                                                                     options:0
                                                                       error:&decodingError];
            
            NSInteger counter = 0;
            NSMutableArray *assetArray = [[NSMutableArray alloc]init];
            NSMutableArray<NSString *> *assetList = [[NSMutableArray alloc]init];
            NSArray* requiredSymbol = @[@"AMZN", @"AAPL",@"MLGO", @"INTC", @"AMTM", @"ARCA", @"ANAB", @"ABNB"];
            for (NSDictionary *dict in responseArray) {
                if (counter > 25) {
                    break;
                }
                AssetModel *model = [[AssetModel alloc]initWithDictionary: dict];
                if(model != NULL && model.tradable && [requiredSymbol containsObject: model.symbol]) {
                    counter = counter + 1;
                    [assetArray addObject:model];
                    [assetList addObject: model.symbol];
                }
            }
            
            [weakSelf reloadWithAssetList:assetArray];
            [weakSelf subscribeAssetLivePriceConnection:assetList];
        }
    }];
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
