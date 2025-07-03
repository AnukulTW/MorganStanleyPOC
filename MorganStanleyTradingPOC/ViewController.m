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

@interface ViewController ()<UITableViewDataSource>
@property (nonatomic, nonnull, strong) SocketConnectionManager *socket;
@property (nonatomic, nonnull, strong) UITableView *instrumentList;
@property (nonatomic, nonnull, strong) NSArray *assetList;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _socket = [[SocketConnectionManager alloc]init];
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
    _instrumentList.estimatedRowHeight = 100.0;
    _instrumentList.rowHeight = UITableViewAutomaticDimension;
    _instrumentList.dataSource = self;
    [_instrumentList registerClass: [UITableViewCell self]
            forCellReuseIdentifier: @"SampleCell"];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: @"SampleCell"
                                                            forIndexPath:indexPath];
    
    AssetModel *model = _assetList[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _assetList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
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
            NSMutableArray *assetArray = [[NSMutableArray alloc]init];
            for (NSDictionary *dict in responseArray) {
                AssetModel *model = [[AssetModel alloc]initWithDictionary: dict];
                if(model != NULL) {
                    [assetArray addObject:model];
                }
            }
            
            [weakSelf reloadWithAssetList:assetArray];
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

@end
