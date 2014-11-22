//
//  MyPatternInputViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/11.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "MyPatternInputViewController.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "KotsuhiFileManager.h"
#import "TrackingManager.h"

@interface MyPatternInputViewController ()

@end

@implementation MyPatternInputViewController

@synthesize nadView;

@synthesize mypattern;
@synthesize scrollView;
@synthesize edited;

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
    [TrackingManager sendScreenTracking:@"マイパターン登録画面"];
    
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    mypattern = appDelegate.targetMyPattern;
    
    if(mypattern == nil){
        mypattern = [[MyPattern alloc] init];
        
        // 交通手段のデフォルトを電車に設定
        mypattern.transportation = @"電車";
    }
    
    // 初期値をセット
    _patternName.text = mypattern.patternName;
    _visit.text = mypattern.visit;
    _departure.text = mypattern.departure;
    _arrival.text = mypattern.arrival;
    _transportation.text = mypattern.transportation;
    _amount.text = [NSString stringWithFormat:@"%d",mypattern.amount];
    _purpose.text = mypattern.purpose;
    _route.text = mypattern.route;
    _roundtrip.checkBoxSelected = mypattern.roundtrip;
    [_roundtrip setState];
    
    // ScrollViewの高さを定義＆iPhone5対応
    scrollView.contentSize = CGSizeMake(320, 685);
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

- (void)showDoneButton {
    UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:@"完了"
                                                            style:UIBarButtonItemStylePlain target:self action:@selector(doneButton)];
    _inputNavi.rightBarButtonItem = btn;
}

- (void)hiddenDoneButton {
    _inputNavi.rightBarButtonItem = nil;
}

- (void)doneButton {
    [self endTextEdit];
}

- (void)endTextEdit {
    [_patternName endEditing:YES];
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

- (NSArray*)inputCheck {
    NSMutableArray* errorArray = [NSMutableArray array];
    // 未入力フラグ
    BOOL blankFlg = NO;
    
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
        [self updateMyPattern];

        [KotsuhiFileManager saveMyPattern:mypattern];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"マイパターン登録画面―登録" value:nil screen:@"マイパターン登録画面"];
    }
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)updateMyPattern {
    if(_patternName.text.length == 0){
        // パターン名が空の場合は訪問先をセット
        mypattern.patternName = _visit.text;
    } else {
        mypattern.patternName = _patternName.text;
    }
    mypattern.visit = _visit.text;
    mypattern.departure = _departure.text;
    mypattern.arrival = _arrival.text;
    mypattern.transportation = _transportation.text;
    mypattern.amount = [_amount.text intValue];
    mypattern.purpose = _purpose.text;
    mypattern.route = _route.text;
    mypattern.roundtrip = _roundtrip.checkBoxSelected;
}

@end
