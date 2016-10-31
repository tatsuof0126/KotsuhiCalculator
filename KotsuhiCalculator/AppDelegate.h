//
//  AppDelegate.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/12.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kotsuhi.h"
#import "MyPattern.h"
#import "InAppPurchaseManager.h"

#define AD_VIEW 1 // 1=広告表示（リリース時）、0=広告非表示
#define MAKE_SAMPLE_DATA 0 // 0=何もしない（リリース時）、1=テストデータ作成
#define SET_REMOVE_ADS 0 // 0=何もしない（リリース時）、1=購入済みにセット、2=未購入にセット
#define SET_SEND_MAIL 0 // 0=何もしない（リリース時）、1=購入済みにセット、2=未購入にセット

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) Kotsuhi* targetKotsuhi;

@property (strong, nonatomic) MyPattern* targetMyPattern;

@property (strong, nonatomic) UITextField *visit;
@property (strong, nonatomic) UITextField *departure;
@property (strong, nonatomic) UITextField *arrival;
@property (strong, nonatomic) UITextField *transportation;
@property (strong, nonatomic) UITextField *amount;
@property (strong, nonatomic) UITextField *purpose;
@property (strong, nonatomic) UITextField *route;

@property BOOL showInterstitialFlg;

@property (strong, nonatomic) InAppPurchaseManager* purchaseManager;

- (InAppPurchaseManager*)getInAppPurchaseManager;

+ (void)showInterstitial:(UIViewController*)controller;

+ (void)adjustForiPhone5:(UIView*)view;

+ (void)adjustOriginForiPhone5:(UIView*)view;

// + (void)adjustOriginForBeforeiOS6:(UIView*)view;

@end
