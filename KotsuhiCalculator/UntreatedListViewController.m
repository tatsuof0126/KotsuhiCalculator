//
//  UntreatedListViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2015/09/25.
//  Copyright (c) 2015年 Tatsuo Fujiwara. All rights reserved.
//

#import "UntreatedListViewController.h"
#import "AppDelegate.h"
#import "KotsuhiFileManager.h"
#import "ConfigManager.h"
#import "TrackingManager.h"

#define REGIST_BTN 1
#define EDIT_BTN 10
#define CANCEL_BTN 11

@interface UntreatedListViewController ()

@end

@implementation UntreatedListViewController

@synthesize listNavi;
@synthesize untreatedListView;
@synthesize untreatedListByMonth;
@synthesize untreatedMonthList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 画面が開かれたときのトラッキング情報を送る
    [TrackingManager sendScreenTracking:@"未処理一覧画面"];
    
    // TableViewの大きさ定義＆iPhone5対応
    untreatedListView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:untreatedListView];
//    [AppDelegate adjustOriginForBeforeiOS6:untreatedListView];
    
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
    untreatedListView.frame = CGRectMake(0, 64, 320, 316);
    [AppDelegate adjustForiPhone5:untreatedListView];
//    [AppDelegate adjustOriginForBeforeiOS6:untreatedListView];
}

- (void)loadUntreatedList {
    NSArray* untreatedList = [KotsuhiFileManager loadUntreatedList];
    
    // 交通費が0件の場合はメッセージを表示、処理済にするボタンを削除
    if(untreatedList.count == 0){
        _initialText.hidden = NO;
        listNavi.leftBarButtonItem = nil;
    } else {
        _initialText.hidden = YES;
        listNavi.leftBarButtonItem = _editBtn;
    }
    
    untreatedListView.allowsMultipleSelectionDuringEditing = NO;
    
    untreatedListByMonth = [NSMutableArray array];
    untreatedMonthList = [NSMutableArray array];
    
    int listyear = 0;
    int listmonth = 0;
    int subTotalAmount = 0;
    
    NSMutableArray* kotsuhiSubList = [NSMutableArray array];
    
    for (Kotsuhi* kotsuhi in untreatedList) {
        if(listyear != kotsuhi.year || listmonth != kotsuhi.month){
            if(listyear != 0){
                [untreatedMonthList addObject:[NSString stringWithFormat:@"%d年%d月 合計%d円",
                                             listyear, listmonth, subTotalAmount]];
            }
            
            listyear = kotsuhi.year;
            listmonth = kotsuhi.month;
            subTotalAmount = 0;
            
            kotsuhiSubList = [NSMutableArray array];
            [untreatedListByMonth addObject:kotsuhiSubList];
        }
        [kotsuhiSubList addObject:kotsuhi];
        subTotalAmount += [kotsuhi getTripAmount];
    }
    
    if(listyear != 0){
        [untreatedMonthList addObject:[NSString stringWithFormat:@"%d年%d月 合計%d円",
                                     listyear, listmonth, subTotalAmount]];
    }
    
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray* array = [untreatedListByMonth objectAtIndex:section];
    return array.count;
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* array = [untreatedListByMonth objectAtIndex:indexPath.section];
    Kotsuhi* kotsuhi = [array objectAtIndex:indexPath.row];
    
    NSString* cellName = @"KotsuhiCell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    
    if(cell == nil){
        NSLog(@"cell == nil");
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellName];
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
    
    cell.textLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:16];
    cell.textLabel.attributedText = attributedText;
    
    // サブテキスト
    NSString* viewDetailText = [NSString stringWithFormat:@"  %@%@%@(%@) %@ %@",
                                kotsuhi.departure, [kotsuhi getTripArrow], kotsuhi.arrival, kotsuhi.transportation, kotsuhi.purpose, kotsuhi.route];
    
    NSMutableAttributedString* detailStr
    = [[NSMutableAttributedString alloc] initWithString:viewDetailText];
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    cell.detailTextLabel.attributedText = detailStr;
    
    return cell;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return untreatedMonthList.count;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return [untreatedMonthList objectAtIndex:section];
}

// TableView編集時は削除ボタンを出さない
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(untreatedListView.editing == YES){
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSArray* array = [untreatedListByMonth objectAtIndex:indexPath.section];
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
        
        [self loadUntreatedList];
        
        [untreatedListView reloadData];
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"交通費一覧画面―削除" value:nil screen:@"交通費一覧画面"];
    }
    
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    // 編集モードのときはセルを選択されても画面遷移しない
    if ([identifier isEqualToString:@"selectKotsuhi"]) {
        if (untreatedListView.isEditing == YES) {
            return NO;
        }
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    int tag = (int)((UIView*)sender).tag;
    if(tag == REGIST_BTN){
        // 登録ボタン
        appDelegate.targetKotsuhi = nil;
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"未処理一覧画面―登録" value:nil screen:@"未処理一覧画面"];
    } else {
        // 個別の交通費を選択
        NSIndexPath* indexPath = [untreatedListView indexPathForSelectedRow];
        
        NSArray* array = [untreatedListByMonth objectAtIndex:indexPath.section];
        Kotsuhi* kotsuhi = [array objectAtIndex:indexPath.row];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.targetKotsuhi = kotsuhi;
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"未処理一覧画面―既存選択" value:nil screen:@"未処理一覧画面"];
    }
}

- (IBAction)editButton:(id)sender {
    int tag = (int)((UIView*)sender).tag;
    
    if(tag == EDIT_BTN){
        [self startEditing];
    } else if(tag == CANCEL_BTN){
        [self endEditing];
    }
}

- (void)startEditing {
    // TableViewを編集モードにする
    untreatedListView.allowsMultipleSelectionDuringEditing = YES;
    [untreatedListView setEditing:YES animated:YES];
    
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"処理済"
        style:UIBarButtonItemStylePlain target:self action:@selector(treatButton:)];
    listNavi.rightBarButtonItem = btn;
    
    _editBtn.title = @"キャンセル";
    _editBtn.tag = CANCEL_BTN;
}

- (void)endEditing {
    // TableViewの編集モードを終了
    untreatedListView.allowsMultipleSelectionDuringEditing = NO;
    [untreatedListView setEditing:NO animated:YES];
    
    listNavi.rightBarButtonItem = _registBtn;
    
    _editBtn.title = @"処理済にする";
    _editBtn.tag = EDIT_BTN;
}

- (void)treatButton:(id)sender {
    [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"未処理一覧画面―処理済" value:nil screen:@"未処理一覧画面"];

    NSArray* selectedRows = [self.untreatedListView indexPathsForSelectedRows];
    
    for(NSIndexPath* indexPath in selectedRows){
        // 交通費を取得
        NSArray* array = [untreatedListByMonth objectAtIndex:indexPath.section];
        Kotsuhi* kotsuhi = [array objectAtIndex:indexPath.row];
        
        // 処理済にして保存
        kotsuhi.treated = YES;
        [KotsuhiFileManager saveKotsuhi:kotsuhi];
    }
    
    [self endEditing];
    
    [self loadUntreatedList];
    [untreatedListView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [untreatedListView deselectRowAtIndexPath:[untreatedListView indexPathForSelectedRow] animated:NO];
    
    [self loadUntreatedList];
    [untreatedListView reloadData];
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

