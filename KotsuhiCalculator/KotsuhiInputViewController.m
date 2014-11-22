//
//  KotsuhiInputViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/28.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "KotsuhiInputViewController.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "ConfigManager.h"
#import "KotsuhiFileManager.h"
#import "TrackingManager.h"
#import <FelloPush/KonectNotificationsAPI.h>

#define REGIST_BTN 1
#define REGIST_AND_MYPATTERN_BTN 2

@interface KotsuhiInputViewController ()

@end

@implementation KotsuhiInputViewController

@synthesize nadView;

@synthesize kotsuhi;
@synthesize edited;
@synthesize scrollView;

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
    
    // 画面が開かれたときのトラッキング情報を送る
    [TrackingManager sendScreenTracking:@"交通費入力画面"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    kotsuhi = appDelegate.targetKotsuhi;
    
    if(kotsuhi == nil){
        kotsuhi = [[Kotsuhi alloc] init];
        
        // 日付を今日に初期設定
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDate *date = [NSDate date];
        NSDateComponents *dateComps
            = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
        
        kotsuhi.year = dateComps.year;
        kotsuhi.month = dateComps.month;
        kotsuhi.day = dateComps.day;
        
        // 交通手段のデフォルトを電車に設定
        kotsuhi.transportation = @"電車";
    }
    
    // 初期値をセット
    _year.text = [NSString stringWithFormat:@"%d",kotsuhi.year];
    _month.text = [NSString stringWithFormat:@"%d",kotsuhi.month];
    _day.text = [NSString stringWithFormat:@"%d",kotsuhi.day];
    
    _visit.text = kotsuhi.visit;
    _departure.text = kotsuhi.departure;
    _arrival.text = kotsuhi.arrival;
    _transportation.text = kotsuhi.transportation;
    _amount.text = [NSString stringWithFormat:@"%d",kotsuhi.amount];
    _purpose.text = kotsuhi.purpose;
    _route.text = kotsuhi.route;
    _roundtrip.checkBoxSelected = kotsuhi.roundtrip;
    [_roundtrip setState];
    
    // ScrollViewの高さを定義＆iPhone5対応
    scrollView.contentSize = CGSizeMake(320, 726);
    scrollView.frame = CGRectMake(0, 64, 320, 416);
    [AppDelegate adjustForiPhone5:scrollView];
    [AppDelegate adjustOriginForBeforeiOS6:scrollView];
    
    edited = NO;
    
    if([ConfigManager isRemoveAdsFlg] == NO){
        // NADViewの作成（表示はこの時点ではしない）
        nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 431, 320, 50)];
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
    scrollView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:scrollView];
    [AppDelegate adjustOriginForBeforeiOS6:scrollView];
    
    // NADViewを表示
    [self.view addSubview:nadView];
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


- (void)textFieldDidBeginEditing:(UITextField *)textField{
    // 数値入力項目で「0」の場合は入力時に「0」を消す
    if(textField == _amount && [textField.text isEqualToString:@"0"]){
        textField.text = @"";
    }
    
    
    // NSLog(@"y : %f", scrollView.contentOffset.y);
    
    /*
    
    if ((textField == _daten || textField == _tokuten || textField == _steal) &&
        scrollView.contentOffset.y < 155.0f+gameResult.battingResultArray.count*40){
        [scrollView setContentOffset:CGPointMake(0.0f, 155.0f+gameResult.battingResultArray.count*40) animated:YES];
    }
    
    if ((textField == _myscore || textField == _otherscore) &&
        scrollView.contentOffset.y < 20.0f){
        [scrollView setContentOffset:CGPointMake(0.0f, 20.0f) animated:YES];
    }
     
    */
    
    [self showDoneButton];
    
    edited = YES;
}

/*
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    // 数値入力項目で「0」の場合は入力時に「0」を消す
    if(textField.tag == 1 && [textField.text isEqualToString:@"0"]){
        textField.text = @"";
    }
    return YES;
}
*/

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    // 数値入力項目で空の場合は「0」を設定
    if(textField == _amount && [textField.text isEqualToString:@""]){
        textField.text = @"0";
    }
    
    [self hiddenDoneButton];
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    //    NSLog(@"y : %f", scrollView.contentOffset.y);
    /*
    if (textView == _memo &&
        scrollView.contentOffset.y < 345.0f+gameResult.battingResultArray.count*40){
        [scrollView setContentOffset:CGPointMake(0.0f, 345.0f+gameResult.battingResultArray.count*40) animated:YES];
    }
    */
    
    [self showDoneButton];
    
    edited = YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
    [self hiddenDoneButton];
    return YES;
}

- (void)showDoneButton {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"完了"
        style:UIBarButtonItemStylePlain target:self action:@selector(doneButton)];
    _inputNavi.rightBarButtonItem = btn;
}

- (void)hiddenDoneButton {
    _inputNavi.rightBarButtonItem = _mypatternBtn;
}

- (void)doneButton {
    [self endTextEdit];
}

- (void)endTextEdit {
    [_year endEditing:YES];
    [_month endEditing:YES];
    [_day endEditing:YES];
    [_visit endEditing:YES];
    [_departure endEditing:YES];
    [_arrival endEditing:YES];
    [_transportation endEditing:YES];
    [_amount endEditing:YES];
    [_purpose endEditing:YES];
    [_route endEditing:YES];
}

- (IBAction)registButton:(id)sender {
    NSArray* errorArray = [self inputCheck];
    
    // 入力エラーがある場合はダイアログを表示して保存しない
    if(errorArray.count >= 1){
        NSMutableString *errorStr = [NSMutableString string];
        for(int i=0;i<errorArray.count;i++){
            [errorStr appendString:[errorArray objectAtIndex:i]];
            if(i != errorArray.count){
                [errorStr appendString:@"\n"];
            }
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
            message:errorStr delegate:self cancelButtonTitle:@"閉じる" otherButtonTitles:nil];
        [alert show];
        
        return;
    }
    
    // 入力エラーがない場合は保存確認のダイアログを表示
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"保存してよろしいですか？"
        delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
    [alert setTag:((UIButton*)sender).tag]; // ボタン種別を保持
    [alert show];
}

- (NSArray*)inputCheck {
    NSMutableArray* errorArray = [NSMutableArray array];
    // 未入力フラグ
    BOOL blankFlg = NO;
    
    if(_year.text.length == 0 || _month.text.length == 0 || _day.text.length == 0){
        blankFlg = YES;
    } else {
        // 日付チェック
        NSDate* date = [Utility getDate:_year.text month:_month.text day:_day.text];
        if(date == NULL){
            [errorArray addObject:@"日付が正しくありません。"];
        }
    }
    
    if(_visit.text.length == 0){
        blankFlg = YES;
    }
    
    if(_departure.text.length == 0){
        blankFlg = YES;
    }
    
    if(_arrival.text.length == 0){
        blankFlg = YES;
    }
    
    if(_transportation.text.length == 0){
        blankFlg = YES;
    }
    
    if(_amount.text.length == 0){
        blankFlg = YES;
    } else {
        // 数字以外が入っていたらエラーにする
        int amount = [_amount.text intValue];
        
        if(amount == 0 && [_amount.text isEqualToString:@"0"] == NO){
            [errorArray addObject:@"金額が正しくありません"];
        }

        if(amount < 0){
            [errorArray addObject:@"金額が正しくありません"];
        }
    }

    if(_purpose.text.length == 0){
        blankFlg = YES;
    }
    
    if(blankFlg == YES){
        [errorArray addObject:@"入力されていない項目があります"];
    }
    
    return errorArray;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // OKボタンの場合
    if(buttonIndex == 1){
        [self updateKotsuhi];
        
        [KotsuhiFileManager saveKotsuhi:kotsuhi];
        
        // 登録＋マイパターンボタンの場合はマイパターンも保存
        if(alertView.tag == REGIST_AND_MYPATTERN_BTN){
            MyPattern* myPattern = [self makeMyPattern];
            [KotsuhiFileManager saveMyPattern:myPattern];
            
            [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"交通費入力画面―登録＆マイパターン追加" value:nil screen:@"交通費入力画面"];
            
        } else {
            [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"交通費入力画面―登録" value:nil screen:@"交通費入力画面"];
        }
        
        // インタースティシャル広告を表示
        if([ConfigManager isRemoveAdsFlg] == NO){
            [KonectNotificationsAPI beginInterstitial:nil];
        }
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateKotsuhi {
    // 日付は一度カレンダーに変換してから取得する
    NSDate* date = [Utility getDate:_year.text month:_month.text day:_day.text];
    
    // 日時をカレンダーで年月日に分解する
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *dateComps
        = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit fromDate:date];
    
    kotsuhi.year = dateComps.year;
    kotsuhi.month = dateComps.month;
    kotsuhi.day = dateComps.day;
    
    kotsuhi.visit = _visit.text;
    kotsuhi.departure = _departure.text;
    kotsuhi.arrival = _arrival.text;
    kotsuhi.transportation = _transportation.text;
    kotsuhi.amount = [_amount.text intValue];
    kotsuhi.purpose = _purpose.text;
    kotsuhi.route = _route.text;
    kotsuhi.roundtrip = _roundtrip.checkBoxSelected;
}

- (MyPattern*)makeMyPattern {
    MyPattern* myPattern = [[MyPattern alloc] init];
    
    myPattern.patternName = _visit.text;
    myPattern.visit = _visit.text;
    myPattern.departure = _departure.text;
    myPattern.arrival = _arrival.text;
    myPattern.transportation = _transportation.text;
    myPattern.amount = [_amount.text intValue];
    myPattern.purpose = _purpose.text;
    myPattern.route = _route.text;
    myPattern.roundtrip = _roundtrip.checkBoxSelected;
    
    return myPattern;
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [nadView resume];
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
