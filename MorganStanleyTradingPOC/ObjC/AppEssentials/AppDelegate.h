//
//  AppDelegate.h
//  MorganStanleyTradingPOC
//
//  Created by Anukul Bhatnagar on 03/07/25.
//

#import <UIKit/UIKit.h>
@import Firebase;
@interface AppDelegate : UIResponder <UIApplicationDelegate>
@property(nonatomic, strong) FIRRemoteConfig *remoteConfig;
@end

