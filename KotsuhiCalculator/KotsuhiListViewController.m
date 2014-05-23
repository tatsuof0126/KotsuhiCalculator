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
#import <FelloPush/KonectNotificationsAPI.h>

#define REGIST_BTN 1

@interface KotsuhiListViewController ()

@end

@implementation KotsuhiListViewController

@synthesize nadView;

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

    // TableViewの大きさ定義＆iPhone5対応
    kotsuhiListView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:kotsuhiListView];
    [AppDelegate adjustOriginForBeforeiOS6:kotsuhiListView];
    
    if([ConfigManager isRemoveAdsFlg] == NO){
        // NADViewの作成（表示はこの時点ではしない）
        nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 381, 320, 50)];
        [AppDelegate adjustOriginForiPhone5:nadView];
        [AppDelegate adjustOriginForBeforeiOS6:nadView];
        
        [nadView setIsOutputLog:NO];
        [nadView setNendID:@"b863bbfd62a267f888ef5aec544e06ec216b618b" spotID:@"178189"];
        [nadView setDelegate:self];
        
        // NADViewの中身（広告）を読み込み
        [nadView load];
    }
    
}

-(void)nadViewDidFinishLoad:(NADView *)adView {
    // NADViewの中身（広告）の読み込みに成功した場合
    // TableViewの大きさ定義＆iPhone5対応
    kotsuhiListView.frame = CGRectMake(0, 64, 320, 316);
    [AppDelegate adjustForiPhone5:kotsuhiListView];
    [AppDelegate adjustOriginForBeforeiOS6:kotsuhiListView];
    
    // NADViewを表示
    [self.view addSubview:nadView];
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
    
    NSMutableArray* kotsuhiSubList = [NSMutableArray array];
    
    for (Kotsuhi* kotsuhi in kotsuhiList) {
        if(listyear != kotsuhi.year || listmonth != kotsuhi.month){
            [kotsuhiMonthList addObject:[NSString stringWithFormat:@"%d年%d月", kotsuhi.year, kotsuhi.month]];
            listyear = kotsuhi.year;
            listmonth = kotsuhi.month;
            
            kotsuhiSubList = [NSMutableArray array];
            [kotsuhiListByMonth addObject:kotsuhiSubList];
        }
        [kotsuhiSubList addObject:kotsuhi];
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
    
    // メインテキスト
    NSString* viewText = [NSString stringWithFormat:@"%d/%d %@ %d円",
                          kotsuhi.month, kotsuhi.day, kotsuhi.visit, kotsuhi.amount];
    
    cell.textLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:16];
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.lineSpacing = - 2.0f;
    paragrahStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attributedText
        = [[NSMutableAttributedString alloc] initWithString:viewText];
    
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:paragrahStyle
                           range:NSMakeRange(0, attributedText.length)];
    
    cell.textLabel.attributedText = attributedText;
    
    // サブテキスト
    NSString* viewDetailText = [NSString stringWithFormat:@" %@→%@(%@) %@ %@",
                               kotsuhi.departure, kotsuhi.arrival, kotsuhi.transportation, kotsuhi.purpose, kotsuhi.route];
    
    NSMutableAttributedString* detailStr
        = [[NSMutableAttributedString alloc] initWithString:viewDetailText];
    
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
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    int tag = (int)((UIView*)sender).tag;
    if(tag == REGIST_BTN){
        // 追加ボタン
        appDelegate.targetKotsuhi = nil;
    } else {
        // 個別の交通費を選択
        NSIndexPath* indexPath = [kotsuhiListView indexPathForSelectedRow];
        
        NSArray* array = [kotsuhiListByMonth objectAtIndex:indexPath.section];
        Kotsuhi* kotsuhi = [array objectAtIndex:indexPath.row];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.targetKotsuhi = kotsuhi;
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [nadView resume];
    
    [kotsuhiListView deselectRowAtIndexPath:[kotsuhiListView indexPathForSelectedRow] animated:NO];
    
    [self loadKotsuhiList];
    [kotsuhiListView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [nadView pause];
}

- (void)dealloc {
    [nadView setDelegate:nil];
    nadView = nil;
}

@end
