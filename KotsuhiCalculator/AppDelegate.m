//
//  AppDelegate.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/12.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "AppDelegate.h"
#import "ConfigManager.h"
#import "GAI.h"
#import "GADInterstitial.h"
#import "KotsuhiFileManager.h"
#import "TrackingManager.h"
// #import "NADInterstitial.h"

@implementation AppDelegate

@synthesize purchaseManager;

@synthesize targetKotsuhi;
@synthesize targetMyPattern;

@synthesize gadInterstitial;
@synthesize showInterstitialFlg;

@synthesize visit;
@synthesize departure;
@synthesize arrival;
@synthesize transportation;
@synthesize amount;
@synthesize purpose;
@synthesize route;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    // Google Analyticsの初期化
    [self initializeGoogleAnalytics];
    
//    // For AppBank Fello → やめた
//    NSString* appId = @"10646";
//    [KonectNotificationsAPI initialize:nil launchOptions:launchOptions appId:appId];
//
//    // 広告削除アドオン購入済みなら広告表示しない
//    if([ConfigManager isRemoveAdsFlg] == YES){
//        [KonectNotificationsAPI setAdEnabled:NO];
//    } else {
//        [KonectNotificationsAPI setAdEnabled:YES];
//    }
    
    // For AppBank Network(nend)
//    [[NADInterstitial sharedInstance] loadAdWithApiKey:@"bf39fc35e2e4bc28a3b24db609a5778123a335c2" spotId:@"268809"];
    
    // インタースティシャル広告を初期化
    [self prepareGadInterstitial];
    
    // SampleData
    if(MAKE_SAMPLE_DATA == 1){
        [KotsuhiFileManager makeSampleData];
    }
    
    if(SET_REMOVE_ADS == 1){
        [ConfigManager setRemoveAdsFlg:YES];
    }
    if(SET_REMOVE_ADS == 2){
        [ConfigManager setRemoveAdsFlg:NO];
    }
    if(SET_SEND_MAIL == 1){
        [ConfigManager setSendMailFlg:YES];
    }
    if(SET_SEND_MAIL == 2){
        [ConfigManager setSendMailFlg:NO];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (InAppPurchaseManager*)getInAppPurchaseManager {
    if(purchaseManager == nil){
        purchaseManager = [[InAppPurchaseManager alloc] init];
    }
    
    return purchaseManager;
    
}

+ (void)adjustForiPhone5:(UIView*)view {
    // iPhone5対応
    if([UIScreen mainScreen].bounds.size.height == 568){
        CGRect oldRect = view.frame;
        CGRect newRect = CGRectMake(oldRect.origin.x, oldRect.origin.y,
                                    oldRect.size.width, oldRect.size.height+88);
        view.frame = newRect;
    }
}

+ (void)adjustOriginForiPhone5:(UIView*)view {
    // iPhone5対応
    if([UIScreen mainScreen].bounds.size.height == 568){
        CGRect oldRect = view.frame;
        CGRect newRect = CGRectMake(oldRect.origin.x, oldRect.origin.y+88,
                                    oldRect.size.width, oldRect.size.height);
        view.frame = newRect;
    }
}

/*
+ (void)adjustOriginForBeforeiOS6:(UIView*)view {
    // iOS5/6対応
    if([[[UIDevice currentDevice] systemVersion] compare:@"7" options:NSNumericSearch]
       == NSOrderedAscending){
        CGRect oldRect = view.frame;
        CGRect newRect = CGRectMake(oldRect.origin.x, oldRect.origin.y-20,
                                    oldRect.size.width, oldRect.size.height);
        view.frame = newRect;
    }
}
*/

- (void)initializeGoogleAnalytics {
    // トラッキングIDを設定
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-23529359-4"];
    
    // 例外を Google Analytics に送る
    [GAI sharedInstance].trackUncaughtExceptions = YES;
}

/*
+ (void)showInterstitial:(UIViewController*)controller {
    @try {
        // インタースティシャル広告を表示（AppBank Network(Nend)）
        if([ConfigManager isRemoveAdsFlg] == NO){
            [[NADInterstitial sharedInstance] showAdFromViewController:controller];
            
            NADInterstitialShowResult result = [[NADInterstitial sharedInstance] showAdFromViewController:controller];
            switch ( result ){
                case AD_SHOW_SUCCESS:
                    NSLog(@"広告の表示に成功しました。");
                    break;
                case AD_SHOW_ALREADY:
                    NSLog(@"既に広告が表示されています。");
                    break;
                case AD_FREQUENCY_NOT_REACHABLE:
                    NSLog(@"広告のフリークエンシーカウントに達していません。");
                    break;
                case AD_LOAD_INCOMPLETE:
                    NSLog(@"抽選リクエストが実行されていない、もしくは実行中です。");
                    break;
                case AD_REQUEST_INCOMPLETE:
                    NSLog(@"抽選リクエストに失敗しています。");
                    break;
                case AD_DOWNLOAD_INCOMPLETE:
                    NSLog(@"広告のダウンロードが完了していません。");
                    break;
                case AD_CANNOT_DISPLAY:
                    NSLog(@"指定されたViewControllerに広告が表示できませんでした。");
                    break;
            }
        }
    } @catch (NSException *exception) {
        [TrackingManager sendEventTracking:@"Exception" action:@"Exception" label:@"showInterstitial" value:nil screen:@"showInterstitial"];
    }
}
 */

+ (GADBannerView*)makeGadView:(UIViewController<GADBannerViewDelegate>*)controller {
    GADBannerView* gadView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeBanner];
    gadView.delegate = controller;
    gadView.adUnitID = @"ca-app-pub-6719193336347757/1143075455";
    gadView.rootViewController = controller;
    GADRequest* request = [GADRequest request];
    request.testDevices = @[kGADSimulatorID];
    // request.testDevices = @[kGADSimulatorID, @"2dc8fc8942df647fb90b48c2272a59e6"];
    [gadView loadRequest:request];
    return gadView;
}

- (void)prepareGadInterstitial {
    @try {
        gadInterstitial = [[GADInterstitial alloc] initWithAdUnitID:
                           @"ca-app-pub-6719193336347757/4148097455"];
        gadInterstitial.delegate = self;
        [gadInterstitial loadRequest:[GADRequest request]];
    } @catch (NSException *exception) {
        NSLog(@"Exception : %@", [exception description]);
        [TrackingManager sendEventTracking:@"Exception" action:@"Exception" label:@"prepareGadInterstitial" value:nil screen:@"prepareGadInterstitial"];
    }
}

- (void)showGadInterstitial:(UIViewController*)controller {
    int rand = (int)arc4random_uniform(100);
    if(rand >= INTERSTITIAL_FREQ){
        return;
    }
    
    @try {
        if ([gadInterstitial isReady]) {
            [gadInterstitial presentFromRootViewController:controller];
        } else {
            // 広告の準備ができてないならロード失敗と判断して、次回に備え再読み込み
            [self prepareGadInterstitial];
        }
    } @catch (NSException *exception) {
        NSLog(@"Exception : %@", [exception description]);
        [TrackingManager sendEventTracking:@"Exception" action:@"Exception" label:@"showGadInterstitial" value:nil screen:@"showGadInterstitial"];
    }
}

- (void)interstitialDidDismissScreen:(GADInterstitial*)interstitial {
    [self prepareGadInterstitial];
}

// インタースティシャル広告のロードに失敗した場合
- (void)interstitial:(GADInterstitial*)interstitial didFailToReceiveAdWithError:(GADRequestError *)error {
    NSLog(@"didFailToReceiveAdWithError : %@", [error description]);
}


@end
