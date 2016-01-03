//
//  TransitViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2015/10/04.
//  Copyright (c) 2015年 Tatsuo Fujiwara. All rights reserved.
//

#import "TransitViewController.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "TrackingManager.h"

@interface TransitViewController ()

@end

@implementation TransitViewController

@synthesize webView;
@synthesize targetUrl;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 画面が開かれたときのトラッキング情報を送る
    [TrackingManager sendScreenTracking:@"運賃を調べる画面"];
    
    NSURL *url = [NSURL URLWithString:targetUrl];
    NSURLRequest *req = [NSURLRequest requestWithURL:url];
    [webView loadRequest:req];
    
    // WebViewの大きさ定義＆iPhone5対応
    webView.frame = CGRectMake(0, 64, 320, 416);
    [AppDelegate adjustForiPhone5:webView];

    // 広告表示（AppBankSSP）
    if(AD_VIEW == 1 && [ConfigManager isRemoveAdsFlg] == NO){
        NSDictionary *adgparam = @{@"locationid" : @"28513", @"adtype" : @(kADG_AdType_Sp),
                                   @"originx" : @(0), @"originy" : @(581), @"w" : @(320), @"h" : @(50)};
        ADGManagerViewController *adgvc = [[ADGManagerViewController alloc] initWithAdParams:adgparam adView:self.view];
        self.adg = adgvc;
        _adg.delegate = self;
        [_adg setFillerRetry:NO];
        [_adg loadRequest];
    }
}

- (void)ADGManagerViewControllerReceiveAd:(ADGManagerViewController *)adgManagerViewController {
    // 読み込みに成功したら広告を見える場所に移動
    self.adg.view.frame = CGRectMake(0, 431, 320, 50);
    [AppDelegate adjustOriginForiPhone5:self.adg.view];
    
    // WebViewの大きさ定義＆iPhone5対応
    webView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:webView];
}

// ページ読込開始時にインジケータをくるくるさせる
-(void)webViewDidStartLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
}

// ページ読込完了時にインジケータを非表示にする
-(void)webViewDidFinishLoad:(UIWebView*)webView{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end