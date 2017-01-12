//
//  MyPatternListViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/11.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "MyPatternListViewController.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "KotsuhiFileManager.h"
#import "TrackingManager.h"

#define REGIST_BTN 1
#define EDIT_BTN 10
#define CANCEL_BTN 11

@interface MyPatternListViewController ()

@end

@implementation MyPatternListViewController

@synthesize gadView;
@synthesize mypatternListView;
@synthesize mypatternList;

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
    [TrackingManager sendScreenTracking:@"マイパターン画面"];
        
    // TableViewの大きさ定義＆iPhone5対応
    mypatternListView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:mypatternListView];
    
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
    mypatternListView.frame = CGRectMake(0, 64, 320, 316);
    [AppDelegate adjustForiPhone5:mypatternListView];
}

- (void)loadMyPatternList {
    mypatternList = [KotsuhiFileManager loadMyPatternList];

    // マイパターンが0件の場合はメッセージを表示
    if(mypatternList.count == 0){
        _initialText.hidden = NO;
    } else {
        _initialText.hidden = YES;
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

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return mypatternList.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    NSString* cellName = @"MypatternCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellName];
    }

    MyPattern* myPattern = [mypatternList objectAtIndex:indexPath.row];
    
    // メインテキスト
    NSString* viewText = [NSString stringWithFormat:@"%@ %@ %d円%@",
                          myPattern.patternName, myPattern.visit, [myPattern getTripAmount], [myPattern getRoundTripString]];
    
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
    NSString* viewDetailText = [NSString stringWithFormat:@" %@%@%@(%@) %@ %@",
                                myPattern.departure, [myPattern getTripArrow], myPattern.arrival, myPattern.transportation, myPattern.purpose, myPattern.route];
    
    NSMutableAttributedString* detailStr
        = [[NSMutableAttributedString alloc] initWithString:viewDetailText];
    
    cell.detailTextLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:14];
    cell.detailTextLabel.attributedText = detailStr;
    
    return cell;
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    targetField.text = [mypatternList objectAtIndex:indexPath.row];
//    [self dismissViewControllerAnimated:YES completion:nil];
//}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    int tag = (int)((UIView*)sender).tag;
    if(tag == REGIST_BTN){
        // 登録ボタン
        appDelegate.targetMyPattern = nil;
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"マイパターン画面―登録" value:nil screen:@"マイパターン画面"];
    } else {
        // 個別のマイパターンを選択
        NSIndexPath* indexPath = [mypatternListView indexPathForSelectedRow];
        
        MyPattern* myPattern = [mypatternList objectAtIndex:indexPath.row];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.targetMyPattern = myPattern;
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"マイパターン画面―既存選択" value:nil screen:@"マイパターン画面"];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MyPattern* myPattern = [mypatternList objectAtIndex:indexPath.row];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
            message:@"削除してよろしいですか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
        alert.tag = myPattern.mypatternid;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        int mypatternid = (int)alertView.tag;
        
        [KotsuhiFileManager removeMyPattern:mypatternid];
        
        [self loadMyPatternList];
        
        [mypatternListView reloadData];
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"マイパターン画面―削除" value:nil screen:@"マイパターン画面"];
    }
    
}

// TableView編集時は削除ボタンを出さない
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(mypatternListView.editing == YES){
        return UITableViewCellEditingStyleNone;
    } else {
        return UITableViewCellEditingStyleDelete;
    }
}

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath {
    NSMutableArray* newMypatternList = [mypatternList mutableCopy];
    
    MyPattern* myPattern = [newMypatternList objectAtIndex:sourceIndexPath.row];
    [newMypatternList removeObjectAtIndex:sourceIndexPath.row];
    [newMypatternList insertObject:myPattern atIndex:destinationIndexPath.row];
    
    int sort = 0;
    for(MyPattern* myPattern in newMypatternList){
        myPattern.sort = sort;
        [KotsuhiFileManager saveMyPattern:myPattern];
        sort++;
    }
    
    mypatternList = newMypatternList;
}

- (IBAction)editButton:(id)sender {
    int tag = (int)((UIView*)sender).tag;
    if(tag == EDIT_BTN){
        // TableViewを編集モードにする
        [mypatternListView setEditing:YES animated:YES];
        
        _mypatternNavi.rightBarButtonItem = nil;
        
        _editBtn.title = @"戻る";
        _editBtn.tag = CANCEL_BTN;
    } else if(tag == CANCEL_BTN){
        // TableViewの編集モードを終了
        [mypatternListView setEditing:NO animated:YES];
        
        _mypatternNavi.rightBarButtonItem = _registBtn;
        
        _editBtn.title = @"並び替え";
        _editBtn.tag = EDIT_BTN;
    }
}

- (void)removeAdsBar {
    if(gadView != nil && [ConfigManager isRemoveAdsFlg] == YES){
        // 広告表示していて、広告削除した場合は表示を消す
        [gadView removeFromSuperview];
        gadView.delegate = nil;
        gadView = nil;
        
        // TableViewの大きさ定義＆iPhone5対応
        mypatternListView.frame = CGRectMake(0, 64, 320, 366);
        [AppDelegate adjustForiPhone5:mypatternListView];
    }
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self removeAdsBar];
    
    [mypatternListView deselectRowAtIndexPath:[mypatternListView indexPathForSelectedRow] animated:NO];
    
    [self loadMyPatternList];
    [mypatternListView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    // 広告表示フラグが立っていたら広告表示（表示されるかどうかはランダム）
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    if(appDelegate.showInterstitialFlg == YES){
        if(AD_VIEW == 1 && [ConfigManager isRemoveAdsFlg] == NO){
            [appDelegate showGadInterstitial:self];
            // [AppDelegate showInterstitial:self];
            appDelegate.showInterstitialFlg = NO;
        }
    }
    
}

- (void)dealloc {
    gadView.delegate = nil;
    gadView = nil;
}

@end
