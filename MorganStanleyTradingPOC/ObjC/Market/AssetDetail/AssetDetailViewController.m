//
//  AssetDetailViewController.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 11/07/25.
//

#import "AssetDetailViewController.h"
#import "AssetDetailView.h"

@interface AssetDetailViewController ()
@property (nonatomic, strong) NSString *assetName;
@property (nonatomic, nonnull ,strong) AssetDetailView *detailView;
@property (nonatomic, nonnull ,strong) AssetPriceModel *priceModel;

@end

@implementation AssetDetailViewController

- (instancetype)initWithAssetName:(NSString *)assetName priceModel: (AssetPriceModel *)model {
    self = [super init];
    if (self) {
        _assetName = assetName;
        _priceModel = model;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *notificationName = [@"AssetPriceDidChange_" stringByAppendingString:_assetName];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(assetPriceDidChange:)
                                                 name: notificationName
                                               object:nil];
    [self setupUIComponents];
    [self layoutContraints];
    [self configureAssetDetailView];
    self.navigationItem.title = _assetName;
}

- (void)setupUIComponents {
    _detailView = [[AssetDetailView alloc]init];
    _detailView.translatesAutoresizingMaskIntoConstraints = NO;
}

- (void)layoutContraints {
    [self.view addSubview:_detailView];
    [NSLayoutConstraint activateConstraints: @[
        [_detailView.leadingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.leadingAnchor constant: 20],
        [_detailView.topAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.topAnchor],
        [_detailView.trailingAnchor constraintEqualToAnchor: self.view.safeAreaLayoutGuide.trailingAnchor constant: -20],
        [_detailView.heightAnchor constraintEqualToConstant: 70]
    ]];
}

- (void)configureAssetDetailView {
    [_detailView configureWithPrice: _priceModel];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)assetPriceDidChange: (NSNotification *)notification {
    __weak typeof(self) weakSelf = self;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(),^ {
            NSDictionary *userInfo = notification.userInfo;
            if([[userInfo allKeys] containsObject: @"priceModel"]) {
                AssetPriceModel *model = userInfo[@"priceModel"];
                weakSelf.priceModel = model;
                [weakSelf.detailView configureWithPrice: model];
            }
        });
    });

}

@end
