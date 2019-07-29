//
//  ConfigViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/28.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "ConfigViewController.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "TrackingManager.h"
#import "KotsuhiFileManager.h"
#import "Utility.h"

@interface ConfigViewController ()

@end

@implementation ConfigViewController

@synthesize gadView;
@synthesize scrollView;
@synthesize reviewLabel;
@synthesize otherappLabel;
@synthesize inputNavi;
@synthesize versionName;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 画面が開かれたときのトラッキング情報を送る
    [TrackingManager sendScreenTracking:@"設定画面"];
    
    _transportationText.text = [ConfigManager getDefaultTransportation];
    _purposeText.text = [ConfigManager getDefaultPurpose];
    
    _iccardSearch.checkBoxSelected = [ConfigManager isICCardSearch];
    [_iccardSearch setState];
    [_iccardSearch addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(iccardButton:)]];
    
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    versionName.text = [NSString stringWithFormat:@"version%@",version];

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionName.text = [NSString stringWithFormat:@"version%@",version];
    
    // すでにアドオンをすべて購入済みならボタンを消す
    // if([ConfigManager isRemoveAdsFlg] == YES && [ConfigManager isSendMailFlg] == YES){
    //     inputNavi.rightBarButtonItem = nil;
    // }
    
    // AppStoreへリンクのタップを受け取るため
    reviewLabel.userInteractionEnabled = YES;
    [reviewLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];

    otherappLabel.userInteractionEnabled = YES;
    [otherappLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];
    
    // ScrollViewの高さを定義＆iPhone5対応
    scrollView.contentSize = CGSizeMake(320, 654);
    scrollView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:scrollView];
    
    // 広告表示（admob）
    if(AD_VIEW == 1 && [ConfigManager isRemoveAdsFlg] == NO){
        gadView = [AppDelegate makeGadView:self];
    }
}

- (void)adViewDidReceiveAd:(GADBannerView*)adView {
    // 読み込みに成功したら広告を表示
    gadView.frame = CGRectMake(0, 381, 320, 50);
    [AppDelegate adjustOriginForiPhone5:gadView];
    [self.view addSubview:gadView];
    
    // TableViewの大きさ定義＆iPhone5対応
    scrollView.frame = CGRectMake(0, 64, 320, 316);
    [AppDelegate adjustForiPhone5:scrollView];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self showDoneButton];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self hiddenDoneButton];
    return YES;
}

// 改行を押したらキーボードを閉じる
- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)showDoneButton {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"完了"
        style:UIBarButtonItemStylePlain target:self action:@selector(doneButton)];
    inputNavi.rightBarButtonItem = btn;
}

- (void)hiddenDoneButton {
    // すでにアドオンをすべて購入済みならボタンを消す
    // if([ConfigManager isRemoveAdsFlg] == YES && [ConfigManager isSendMailFlg] == YES){
    //     inputNavi.rightBarButtonItem = nil;
    // } else {
        inputNavi.rightBarButtonItem = _removeAdsBtn;
    // }
}

- (void)doneButton {
    [_transportationText endEditing:YES];
    [_purposeText endEditing:YES];
}

- (IBAction)transportationEdited:(id)sender {
    [ConfigManager setDefaultTransportation:((UITextField*)sender).text];
}

- (IBAction)purposeEdited:(id)sender {
    [ConfigManager setDefaultPurpose:((UITextField*)sender).text];
}

- (IBAction)departureEdited:(id)sender {
    [ConfigManager setDefaultDeparture:((UITextField*)sender).text];
}

- (void)iccardButton:(UITapGestureRecognizer*)sender {
    [_iccardSearch checkboxPush:_iccardSearch];
    [ConfigManager setICCardSearch:_iccardSearch.selected];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tapAction:(UITapGestureRecognizer*)sender{
    if(sender.view == reviewLabel){
//        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=578136103&mt=8&type=Purple+Software"];
        //        http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=578136103&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8

//        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=578136103&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"];
        
        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id881505236?action=write-review"];
        [[UIApplication sharedApplication] openURL:url];
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"設定画面―レビューを書く" value:nil screen:@"設定画面"];
    } else if(sender.view == otherappLabel){
        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/developer/tatsuo-fujiwara/id578136106"];
        // NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.com/apps/itunes-u/TatsuoFujiwara"];
        [[UIApplication sharedApplication] openURL:url];
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"設定画面―他のアプリを見る" value:nil screen:@"設定画面"];
    }
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (void)removeAdsBar {
    if(gadView != nil && [ConfigManager isRemoveAdsFlg] == YES){
        // 広告表示していて、広告削除した場合は表示を消す
        [gadView removeFromSuperview];
        gadView.delegate = nil;
        gadView = nil;
        
        // TableViewの大きさ定義＆iPhone5対応
        scrollView.frame = CGRectMake(0, 64, 320, 366);
        [AppDelegate adjustForiPhone5:scrollView];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self removeAdsBar];
}

- (void)dealloc {
    gadView.delegate = nil;
    gadView = nil;
}

@end
