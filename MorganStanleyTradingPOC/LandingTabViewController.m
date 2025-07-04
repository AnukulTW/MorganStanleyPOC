//
//  LandingTabViewController.m
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import "LandingTabViewController.h"
#import "TradeViewController.h"
#import "NewsListViewController.h"

@implementation LandingTabViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Create first view controller
    TradeViewController *firstVC = [[TradeViewController alloc] init];
    UINavigationController *firstNav = [[UINavigationController alloc] initWithRootViewController:firstVC];
    firstVC.title = @"Trade";
    firstVC.tabBarItem.image = [UIImage imageNamed:@"home_icon"];

    // Create second view controller
    NewsListViewController *secondVC = [[NewsListViewController alloc] init];
    UINavigationController *secondNav = [[UINavigationController alloc] initWithRootViewController:secondVC];
    secondVC.title = @"News";
    secondVC.tabBarItem.image = [UIImage imageNamed:@"settings_icon"];

    // Assign view controllers to tab bar
    self.viewControllers = @[firstNav, secondNav];

    // Optional: Customize appearance
    self.tabBar.tintColor = [UIColor systemBlueColor];
    self.tabBar.backgroundColor = [UIColor whiteColor];
}

@end
