//
//  KotsuhiInputViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/28.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "KotsuhiInputViewController.h"
#import "AppDelegate.h"
#import "SelectInputViewController.h"
#import "TransitViewController.h"
#import "Utility.h"
#import "ConfigManager.h"
#import "KotsuhiFileManager.h"
#import "TrackingManager.h"
#import "NADInterstitial.h"

@interface KotsuhiInputViewController ()

@end

@implementation KotsuhiInputViewController

@synthesize gadView;
@synthesize kotsuhi;
@synthesize edited;
@synthesize mypatternid;
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
        NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        NSDate *date = [NSDate date];
        NSDateComponents *dateComps
            = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
        
        kotsuhi.year = (int)dateComps.year;
        kotsuhi.month = (int)dateComps.month;
        kotsuhi.day = (int)dateComps.day;
        
        // 交通手段・目的補足のデフォルトを設定
        kotsuhi.transportation = [ConfigManager getDefaultTransportation];
        kotsuhi.purpose = [ConfigManager getDefaultPurpose];
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
    _treated.checkBoxSelected = kotsuhi.treated;
    [_treated setState];
    
    mypatternid = 0;
    _registmypattern.checkBoxSelected = NO;
    [_registmypattern setState];
    
    if(kotsuhi.kotsuhiid == 0){
        // 新規登録の場合は処理済チェックを消し、それ以下の項目を40px上に上げる
        _treated.hidden = YES;
        _treatedLabel.hidden = YES;
        
        [self setFrameOriginY:_registBtn originY:_registBtn.frame.origin.y-40];
        [self setFrameOriginY:_registmypattern originY:_registmypattern.frame.origin.y-40];
        [self setFrameOriginY:_mypatternLabel originY:_mypatternLabel.frame.origin.y-40];
    }
    
    if(kotsuhi.kotsuhiid != 0 && MAKE_SAMPLE_DATA != 1){
        [_registBtn setTitle:@"　更 新　" forState:UIControlStateNormal];
//        [_registMypatternBtn setTitle:@"更新 ＆ マイパターン追加" forState:UIControlStateNormal];
    }

    edited = NO;

    // ScrollViewの高さを定義＆iPhone5対応
    scrollView.contentSize = CGSizeMake(320, 726);
    scrollView.frame = CGRectMake(0, 64, 320, 416);
    [AppDelegate adjustForiPhone5:scrollView];
    
    // 広告表示（admob）
    if(AD_VIEW == 1 && [ConfigManager isRemoveAdsFlg] == NO){
        gadView = [AppDelegate makeGadView:self];
    }
}

- (void)adViewDidReceiveAd:(GADBannerView*)adView {
    // 読み込みに成功したら広告を表示
    gadView.frame = CGRectMake(0, 431, 320, 50);
    [AppDelegate adjustOriginForiPhone5:gadView];
    [self.view addSubview:gadView];
    
    // TableViewの大きさ定義＆iPhone5対応
    scrollView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:scrollView];
}

- (void)setFrameOriginY:(UIView*)view originY:(int)originY {
    view.frame = CGRectMake(view.frame.origin.x, originY, view.frame.size.width, view.frame.size.height);
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

    // 下の方の項目を入力する場合はスクロール
    if((textField == _amount || textField == _purpose || textField == _route) &&
       scrollView.contentOffset.y < 174.0f){
        [scrollView setContentOffset:CGPointMake(0.0f, 174.0f) animated:YES];
    }
    
    [self showDoneButton];
    edited = YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    // 数値入力項目で空の場合は「0」を設定
    if(textField == _amount && [textField.text isEqualToString:@""]){
        textField.text = @"0";
    }
    
    [self hiddenDoneButton];
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self showDoneButton];
    edited = YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {
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
    [alert show];
}

- (IBAction)transitButton:(id)sender {
    if(_departure.text.length == 0 || _arrival.text.length == 0){
        [Utility showAlert:@"出発地と到着地を入力してください"];
        return;
    }
    
    [self performSegueWithIdentifier:@"transitSegue" sender:self];
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
        
        // チェックが入っている場合はマイパターンにも登録
        if(_registmypattern.checkBoxSelected == YES){
            MyPattern* myPattern = [self makeMyPattern];
            [KotsuhiFileManager saveMyPattern:myPattern];
            
            [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"交通費入力画面―登録＆マイパターン追加" value:nil screen:@"交通費入力画面"];
            
        } else {
            [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"交通費入力画面―登録" value:nil screen:@"交通費入力画面"];
        }
        
        // インタースティシャル広告表示フラグを立てる
        if([ConfigManager isRemoveAdsFlg] == NO){
            AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
            appDelegate.showInterstitialFlg = YES;
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
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *dateComps
        = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    
    kotsuhi.year = (int)dateComps.year;
    kotsuhi.month = (int)dateComps.month;
    kotsuhi.day = (int)dateComps.day;
    
    kotsuhi.visit = _visit.text;
    kotsuhi.departure = _departure.text;
    kotsuhi.arrival = _arrival.text;
    kotsuhi.transportation = _transportation.text;
    kotsuhi.amount = [_amount.text intValue];
    kotsuhi.purpose = _purpose.text;
    kotsuhi.route = _route.text;
    kotsuhi.roundtrip = _roundtrip.checkBoxSelected;
    kotsuhi.treated = _treated.checkBoxSelected;
}

- (MyPattern*)makeMyPattern {
    MyPattern* myPattern = nil;

    if(mypatternid != 0){
        myPattern = [KotsuhiFileManager loadMyPattern:mypatternid];
    } else {
        myPattern = [[MyPattern alloc] init];
        myPattern.patternName = _visit.text;
    }
    
    myPattern.mypatternid = mypatternid;
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

-(void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    NSString* segueStr = [segue identifier];
    
    NSString* labelStr = [NSString stringWithFormat:@"交通費入力画面―%@",segueStr];
    [TrackingManager sendEventTracking:@"Button" action:@"Push" label:labelStr value:nil screen:@"交通費入力画面"];
    
    if ([segueStr isEqualToString:@"visitSegue"] == YES) {
        SelectInputViewController* controller = [segue destinationViewController];
        controller.selectType = VISIT;
        controller.targetTextField = _visit;
    } else if ([segueStr isEqualToString:@"departureSegue"] == YES) {
        SelectInputViewController* controller = [segue destinationViewController];
        controller.selectType = DEPARTURE;
        controller.targetTextField = _departure;
    } else if ([segueStr isEqualToString:@"arrivalSegue"] == YES) {
        SelectInputViewController* controller = [segue destinationViewController];
        controller.selectType = ARRIVAL;
        controller.targetTextField = _arrival;
    } else if ([segueStr isEqualToString:@"transitSegue"] == YES) {
        TransitViewController* controller = [segue destinationViewController];
        
        NSString* departureStr = [_departure.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
        NSString* arrivalStr = [_arrival.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
        NSString* routeStr = [_route.text stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet alphanumericCharacterSet]];
        
        NSString* iccardStr;
        if([ConfigManager isICCardSearch] == YES){
            iccardStr = @"ic";
        } else {
            iccardStr = @"normal";
        }
        
        controller.targetUrl = [NSString stringWithFormat:@"https://transit.yahoo.co.jp/search/result?from=%@&via=%@&to=%@&type=5&al=1&shin=1&ex=1&hb=1&lb=1&sr=1&s=0&expkind=1&ws=2&ticket=%@",departureStr, routeStr, arrivalStr, iccardStr];
    }
}

- (IBAction)onTap:(id)sender {
    [self.view endEditing:YES];
}

- (void)dealloc {
    gadView.delegate = nil;
    gadView = nil;
}

@end
