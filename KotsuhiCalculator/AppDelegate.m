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
#import "KotsuhiFileManager.h"

@implementation AppDelegate

@synthesize purchaseManager;

@synthesize targetKotsuhi;
@synthesize targetMyPattern;

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

@end
