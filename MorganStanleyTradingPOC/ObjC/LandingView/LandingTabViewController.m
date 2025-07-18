//
//  LandingTabViewController.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "LandingTabViewController.h"
#import "TradeViewController.h"
#import "MarketViewController.h"
#import "MorganStanleyTradingPOC-Swift.h"

#define USE_SWIFT_API 1

@implementation LandingTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create a dispatch group to coordinate async view loads
    dispatch_group_t group = dispatch_group_create();

    __block UIViewController *tradeVC = nil;
    __block UIViewController *newsVC = nil;

    // Start loading Trade Swift View
    dispatch_group_enter(group);
#if USE_SWIFT_API
    [TradeViewCoordinator makeTradeViewControllerWithCompletion:^(UIViewController * _Nonnull viewController) {
        tradeVC = viewController;
        tradeVC.edgesForExtendedLayout = UIRectEdgeNone;
        dispatch_group_leave(group);
    }];
#else
    TradeViewController *tvc = [[TradeViewController alloc] init];
    tradeVC = tvc;
    tradeVC.title = @"Trade";
    tradeVC.tabBarItem.image = [UIImage imageNamed:@"trade"];
    dispatch_group_leave(group);
#endif

    // Start loading News Swift View
    dispatch_group_enter(group);
    [NewsFeedCoordinator makeNewsFeedViewControllerWithCompletion:^(UIViewController * _Nonnull viewController) {
        newsVC = viewController;
        newsVC.edgesForExtendedLayout = UIRectEdgeNone;
        dispatch_group_leave(group);
    }];

    // Create Objective-C Market VC immediately
    MarketViewController *marketVC = [[MarketViewController alloc] init];
    UINavigationController *marketNav = [[UINavigationController alloc] initWithRootViewController:marketVC];
    marketVC.title = @"Market";
    marketVC.tabBarItem.image = [UIImage systemImageNamed:@"dollarsign.circle"];

    // Once both Swift views are loaded...
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        UINavigationController *tradeNav = [[UINavigationController alloc] initWithRootViewController:tradeVC];
        tradeVC.title = @"Trade";
        tradeVC.tabBarItem.image = [UIImage systemImageNamed:@"chart.line.uptrend.xyaxis"];

        UINavigationController *newsNav = [[UINavigationController alloc] initWithRootViewController:newsVC];
        newsVC.title = @"News";
        newsVC.tabBarItem.image = [UIImage systemImageNamed:@"newspaper"];

        // Assign to tab bar controller
        self.viewControllers = @[tradeNav, marketNav, newsNav];

        // Optional: Appearance
        self.tabBar.tintColor = [UIColor systemBlueColor];
        self.tabBar.backgroundColor = [UIColor whiteColor];
    });
}

@end
