//
//  KotsuhiListViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/28.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "KotsuhiListViewController.h"
#import "AppDelegate.h"
#import "KotsuhiFileManager.h"
#import "ConfigManager.h"
#import "TrackingManager.h"

#define REGIST_BTN 1

@interface KotsuhiListViewController ()

@end

@implementation KotsuhiListViewController

@synthesize kotsuhiListView;
@synthesize kotsuhiListByMonth;
@synthesize kotsuhiMonthList;

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
    [TrackingManager sendScreenTracking:@"交通費一覧画面"];
    
    // TableViewの大きさ定義＆iPhone5対応
    kotsuhiListView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:kotsuhiListView];
//    [AppDelegate adjustOriginForBeforeiOS6:kotsuhiListView];

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
    self.adg.view.frame = CGRectMake(0, 381, 320, 50);
    [AppDelegate adjustOriginForiPhone5:self.adg.view];
//    [AppDelegate adjustOriginForBeforeiOS6:self.adg.view];
    
    // TableViewの大きさ定義＆iPhone5対応
    kotsuhiListView.frame = CGRectMake(0, 64, 320, 316);
    [AppDelegate adjustForiPhone5:kotsuhiListView];
//    [AppDelegate adjustOriginForBeforeiOS6:kotsuhiListView];
}

- (void)loadKotsuhiList {
    NSArray* kotsuhiList = [KotsuhiFileManager loadKotsuhiList];
    
    // 交通費が0件の場合はメッセージを表示
    if(kotsuhiList.count == 0){
        _initialText.hidden = NO;
    } else {
        _initialText.hidden = YES;
    }
    
    kotsuhiListByMonth = [NSMutableArray array];
    kotsuhiMonthList = [NSMutableArray array];
    
    int listyear = 0;
    int listmonth = 0;
    int subTotalAmount = 0;
    
    NSMutableArray* kotsuhiSubList = [NSMutableArray array];
    
    for (Kotsuhi* kotsuhi in kotsuhiList) {
        if(listyear != kotsuhi.year || listmonth != kotsuhi.month){
            if(listyear != 0){
                [kotsuhiMonthList addObject:[NSString stringWithFormat:@"%d年%d月 合計%d円",
                                         listyear, listmonth, subTotalAmount]];
            }
            
            listyear = kotsuhi.year;
            listmonth = kotsuhi.month;
            subTotalAmount = 0;
            
            kotsuhiSubList = [NSMutableArray array];
            [kotsuhiListByMonth addObject:kotsuhiSubList];
        }
        [kotsuhiSubList addObject:kotsuhi];
        subTotalAmount += [kotsuhi getTripAmount];
    }
    
    if(listyear != 0){
        [kotsuhiMonthList addObject:[NSString stringWithFormat:@"%d年%d月 合計%d円",
                                     listyear, listmonth, subTotalAmount]];
    }
    

    
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

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* array = [kotsuhiListByMonth objectAtIndex:section];
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* array = [kotsuhiListByMonth objectAtIndex:indexPath.section];
    Kotsuhi* kotsuhi = [array objectAtIndex:indexPath.row];
    
    NSString* cellName = @"KotsuhiCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellName];
    }
    
    UIColor* textColor = nil;
    if(kotsuhi.treated == YES){
        textColor = [UIColor blackColor];
    } else {
        textColor = [UIColor blueColor];
    }
    
    // メインテキスト
    NSString* viewText = [NSString stringWithFormat:@"%d/%d %@ %d円%@",
                          kotsuhi.month, kotsuhi.day, kotsuhi.visit, [kotsuhi getTripAmount], [kotsuhi getRoundTripString]];
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.lineSpacing = - 2.0f;
    paragrahStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attributedText
        = [[NSMutableAttributedString alloc] initWithString:viewText];
    
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:paragrahStyle
                           range:NSMakeRange(0, attributedText.length)];
    
    cell.textLabel.textColor = textColor;
    cell.textLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:16];
    cell.textLabel.attributedText = attributedText;
    
    // サブテキスト
    NSString* viewDetailText = [NSString stringWithFormat:@"  %@%@%@(%@) %@ %@",
                               kotsuhi.departure, [kotsuhi getTripArrow], kotsuhi.arrival, kotsuhi.transportation, kotsuhi.purpose, kotsuhi.route];
    
    NSMutableAttributedString* detailStr
        = [[NSMutableAttributedString alloc] initWithString:viewDetailText];
    
    cell.detailTextLabel.textColor = textColor;
    cell.detailTextLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    cell.detailTextLabel.attributedText = detailStr;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 	return kotsuhiMonthList.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [kotsuhiMonthList objectAtIndex:section];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray* array = [kotsuhiListByMonth objectAtIndex:indexPath.section];
        Kotsuhi* kotsuhi = [array objectAtIndex:indexPath.row];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
            message:@"削除してよろしいですか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
        alert.tag = kotsuhi.kotsuhiid;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        int kotsuhiid = (int)alertView.tag;
        
        [KotsuhiFileManager removeKotsuhi:kotsuhiid];
        
        [self loadKotsuhiList];
        
        [kotsuhiListView reloadData];
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"交通費一覧画面―削除" value:nil screen:@"交通費一覧画面"];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    int tag = (int)((UIView*)sender).tag;
    if(tag == REGIST_BTN){
        // 登録ボタン
        appDelegate.targetKotsuhi = nil;
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"交通費一覧画面―登録" value:nil screen:@"交通費一覧画面"];
    } else {
        // 個別の交通費を選択
        NSIndexPath* indexPath = [kotsuhiListView indexPathForSelectedRow];
        
        NSArray* array = [kotsuhiListByMonth objectAtIndex:indexPath.section];
        Kotsuhi* kotsuhi = [array objectAtIndex:indexPath.row];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.targetKotsuhi = kotsuhi;
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"交通費一覧画面―既存選択" value:nil screen:@"交通費一覧画面"];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [kotsuhiListView deselectRowAtIndexPath:[kotsuhiListView indexPathForSelectedRow] animated:NO];
    
    [self loadKotsuhiList];
    [kotsuhiListView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(_adg){
        [_adg resumeRefresh];
    }
    
    // 広告表示フラグが立っていたら広告表示（表示されるかどうかはランダム）
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.showInterstitialFlg == YES){
        if(AD_VIEW == 1 && [ConfigManager isRemoveAdsFlg] == NO){
            [AppDelegate showInterstitial:self];
            appDelegate.showInterstitialFlg = NO;
        }
    }
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(adg_){
        [adg_ pauseRefresh];
    }
}

- (void)dealloc {
    adg_.delegate = nil;
    adg_ = nil;
}

@end
