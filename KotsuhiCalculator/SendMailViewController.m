//
//  SendMailViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2017/11/26.
//  Copyright © 2017年 Tatsuo Fujiwara. All rights reserved.
//

#import "SendMailViewController.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "TrackingManager.h"
#import "KotsuhiFileManager.h"
#import "Utility.h"

@interface SendMailViewController ()

@end

@implementation SendMailViewController

@synthesize gadView;
@synthesize scrollView;
@synthesize inputNavi;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 画面が開かれたときのトラッキング情報を送る
    [TrackingManager sendScreenTracking:@"メール送信画面"];
    
    _sendTo.text = [ConfigManager getDefaultSendTo];
    
    _forWindows.checkBoxSelected = [ConfigManager isForWindows];
    [_forWindows setState];
    [_forWindows addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(forWindowsButton:)]];

    _dayOrder.checkBoxSelected = [ConfigManager isDayOrderAsc];
    [_dayOrder setState];
    [_dayOrder addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                       initWithTarget:self action:@selector(forDayOrderButton:)]];

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
    inputNavi.rightBarButtonItem = _addonBtn;
}

- (void)doneButton {
    [_sendTo endEditing:YES];
}

- (IBAction)sendToEdited:(id)sender {
    [ConfigManager setDefaultSendTo:((UITextField*)sender).text];
}

- (void)forWindowsButton:(UITapGestureRecognizer*)sender {
    [_forWindows checkboxPush:_forWindows];
    [ConfigManager setForWindows:_forWindows.selected];
}

- (void)forDayOrderButton:(UITapGestureRecognizer*)sender {
    [_dayOrder checkboxPush:_dayOrder];
    [ConfigManager setDayOrderAsc:_dayOrder.selected];
}

- (IBAction)sendUntreated:(id)sender {
    [self.view endEditing:YES];
    
    if([ConfigManager isSendMailFlg] == NO){
        [self showAlertForNeedAddon];
        return;
    }
    
    NSArray* targetKotsuhiList = [KotsuhiFileManager loadUntreatedList];
    if([ConfigManager isDayOrderAsc]){
        targetKotsuhiList = targetKotsuhiList.reverseObjectEnumerator.allObjects;
    }
    
    [self sendMail:targetKotsuhiList sendAll:NO];
}

- (IBAction)sendAll:(id)sender {
    [self.view endEditing:YES];
    
    if([ConfigManager isSendMailFlg] == NO){
        [self showAlertForNeedAddon];
        return;
    }
    
    NSArray* targetKotsuhiList = [KotsuhiFileManager loadKotsuhiList];
    if([ConfigManager isDayOrderAsc]){
        targetKotsuhiList = targetKotsuhiList.reverseObjectEnumerator.allObjects;
    }
    
    [self sendMail:targetKotsuhiList sendAll:YES];
}

- (void)showAlertForNeedAddon {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:@"メール送信機能を利用するにはアドオンを購入してください。\n\nすでに購入済みの場合はアドオン購入画面からリストアをお試しください。" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"アドオン購入画面へ" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"メール送信画面―アドオン入手画面へ遷移" value:nil screen:@"メール送信画面"];
        [self performSegueWithIdentifier:@"getaddon" sender:self];
    }]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)sendMail:(NSArray*)kotsuhiList sendAll:(BOOL)sendAll {
    // メールを利用できるかチェック
    if ([MFMailComposeViewController canSendMail] == NO) {
        [Utility showAlert:@"メールアカウントが設定されていません。\niPhoneの設定アプリからメールアカウントを設定してください。"];
        return;
    }
    
    _sendAll = sendAll;
    
    MFMailComposeViewController* controller = [[MFMailComposeViewController alloc] init];
    [controller setMailComposeDelegate:self];
    
    NSString* sendto = [ConfigManager getDefaultSendTo];
    NSArray* sendtoArray = [sendto componentsSeparatedByString:@","];
    [controller setToRecipients:sendtoArray];
    
    NSString* title = sendAll ? @"交通費一覧" : @"未処理交通費一覧";
    
    NSCalendar* calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *date = [NSDate date];
    NSDateComponents *dateComps
        = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:date];
    int year = (int)dateComps.year;
    int month = (int)dateComps.month;
    int day = (int)dateComps.day;
    
    [controller setSubject:[NSString stringWithFormat:@"%@（%d年%d月%d日）",title, year, month, day]];
    
    [controller setMessageBody:@"交通費メモから送信" isHTML:NO];
    
    // CSVデータを作成
    NSString* dataStr = [self makeCsvString:kotsuhiList];
    
    // CSVデータをNSDataに変換（Windows用が指定されていた場合はSJISでエンコード）
    NSData* data = nil;
    if([ConfigManager isForWindows]){
        data = [dataStr dataUsingEncoding:NSShiftJISStringEncoding];
    } else {
        data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    // NSDataオブジェクトをファイルとして添付。MimeTypeはtext/csv
    NSString* fiilenameprefix = sendAll ? @"kotsuhiall" : @"kotsuhi";
    NSString* filename = [NSString stringWithFormat:@"%@%04d%02d%02d.csv",fiilenameprefix, year, month, day];
    [controller addAttachmentData:data mimeType:@"text/csv" fileName:filename];
    
    // メール送信用のビューを表示
    [self presentViewController:controller animated:YES completion:nil];
}

- (NSString*)makeCsvString:(NSArray*)kotsuhiList {
    NSMutableString* retString = [NSMutableString stringWithString:@""];
    
    NSArray* dataItemArray = [KotsuhiFileManager loadDataItemList];
    NSString* newlineStr = [ConfigManager isForWindows] ? @"\r\n" : @"\n";
    
    // ヘッダー行を作る
    for(DataItem* dataItem in dataItemArray){
        if(dataItem.usecsv == NO){
            continue;
        }
        [retString appendString:dataItem.name];
        [retString appendString:@","];
    }
    [retString deleteCharactersInRange:NSMakeRange(retString.length-1, 1)];
    [retString appendString:newlineStr];
    
    for(Kotsuhi* kotsuhi in kotsuhiList){
        for(DataItem* dataItem in dataItemArray){
            if(dataItem.usecsv == NO){
                continue;
            }
            switch (dataItem.itemId) {
                case ITEMID_YEAR:
                    [retString appendFormat:@"%d", kotsuhi.year];
                    break;
                case ITEMID_MONTH:
                    [retString appendFormat:@"%d", kotsuhi.month];
                    break;
                case ITEMID_DAY:
                    [retString appendFormat:@"%d", kotsuhi.day];
                    break;
                case ITEMID_YYYYMMDD:
                    [retString appendFormat:@"%04d%02d%02d", kotsuhi.year, kotsuhi.month, kotsuhi.day];
                    break;
                case ITEMID_VISIT:
                    [retString appendString:[Utility replaceComma:kotsuhi.visit]];
                    break;
                case ITEMID_DEPARTURE:
                    [retString appendString:[Utility replaceComma:kotsuhi.departure]];
                    break;
                case ITEMID_ARRIVAL:
                    [retString appendString:[Utility replaceComma:kotsuhi.arrival]];
                    break;
                case ITEMID_TRANSPORTATION:
                    [retString appendString:[Utility replaceComma:kotsuhi.transportation]];
                    break;
                case ITEMID_AMOUNT_ONEWAY:
                    [retString appendFormat:@"%d", kotsuhi.amount];
                    break;
                case ITEMID_AMOUNT:
                    [retString appendFormat:@"%d", [kotsuhi getTripAmount]];
                    break;
                case ITEMID_ROUNDTRIP:
                    [retString appendString:kotsuhi.roundtrip ? @"往復" : @""];
                    break;
                case ITEMID_PURPOSE:
                    [retString appendString:[Utility replaceComma:kotsuhi.purpose]];
                    break;
                case ITEMID_ROUTE:
                    [retString appendString:[Utility replaceComma:kotsuhi.route]];
                    break;
                case ITEMID_TREATED:
                    [retString appendString:kotsuhi.treated ? @"処理済" : @""];
                    break;
                default:
                    break;
            }
            [retString appendString:@","];
        }
        
        [retString deleteCharactersInRange:NSMakeRange(retString.length-1, 1)];
        [retString appendString:newlineStr];
    }
    
    // NSLog(@"MailBody : \n%@", retString);

    return retString;
}

// メール送信処理完了時のイベント
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [controller dismissViewControllerAnimated:NO completion:^ {
        switch (result){
                // キャンセル
            case MFMailComposeResultCancelled:
                break;
                // 保存
            case MFMailComposeResultSaved:
                break;
                // 送信成功
            case MFMailComposeResultSent:
                [self mailSent];
                break;
                // 送信失敗
            case MFMailComposeResultFailed:
                [Utility showAlert:@"送信に失敗しました"];
                break;
            default:
                break;
        }
    }];
}

- (void)mailSent {
    if(_sendAll == YES){
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"メール送信画面―メール送信（全件）" value:nil screen:@"メール送信画面"];
        // [Utility showAlert:@"送信完了" message:@"メールを送信しました"];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"送信完了" message:@"メールを送信しました。" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [AppDelegate requestReview]; // レビュー依頼
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"メール送信画面―メール送信（未処理）" value:nil screen:@"メール送信画面"];
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"送信完了" message:@"メールを送信しました。\n\n送信した交通費データを処理済にしますか？" preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"処理済にする" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            [self treatSentKotsuhi];
        }]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"変更しない" style:UIAlertActionStyleDefault handler:nil]];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)treatSentKotsuhi {
    NSArray* untreatedKotsuhiList = [KotsuhiFileManager loadUntreatedList];
    for(Kotsuhi* kotsuhi in untreatedKotsuhiList){
        kotsuhi.treated = YES;
        [KotsuhiFileManager saveKotsuhi:kotsuhi];
    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:@"処理済に変更しました。" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [AppDelegate requestReview]; // レビュー依頼
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
    
    [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"メール送信画面―メール送信後の処理済" value:nil screen:@"メール送信画面"];
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
