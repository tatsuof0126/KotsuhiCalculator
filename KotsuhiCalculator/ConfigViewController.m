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

#define ALERT_DONE 1
#define ALERT_MOVE_ADDON 2

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
    _sendTo.text = [ConfigManager getDefaultSendTo];
    
    _iccardSearch.checkBoxSelected = [ConfigManager isICCardSearch];
    [_iccardSearch setState];
    [_iccardSearch addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                        initWithTarget:self action:@selector(iccardButton:)]];
    
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
//    versionName.text = [NSString stringWithFormat:@"version%@",version];

    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    versionName.text = [NSString stringWithFormat:@"version%@",version];
    
    
    _forWindows.checkBoxSelected = [ConfigManager isForWindows];
    [_forWindows setState];
    [_forWindows addGestureRecognizer:[[UITapGestureRecognizer alloc]
                                         initWithTarget:self action:@selector(forWindowsButton:)]];
    
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
    [_sendTo endEditing:YES];
}

- (IBAction)transportationEdited:(id)sender {
    [ConfigManager setDefaultTransportation:((UITextField*)sender).text];
}

- (IBAction)purposeEdited:(id)sender {
    [ConfigManager setDefaultPurpose:((UITextField*)sender).text];
}

- (IBAction)sendToEdited:(id)sender {
    [ConfigManager setDefaultSendTo:((UITextField*)sender).text];
}

- (void)iccardButton:(UITapGestureRecognizer*)sender {
    [_iccardSearch checkboxPush:_iccardSearch];
    [ConfigManager setICCardSearch:_iccardSearch.selected];
}

- (void)forWindowsButton:(UITapGestureRecognizer*)sender {
    [_forWindows checkboxPush:_forWindows];
    [ConfigManager setForWindows:_forWindows.selected];
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
        
        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id881505236"];
        [[UIApplication sharedApplication] openURL:url];
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"設定画面―レビューを書く" value:nil screen:@"設定画面"];
    } else if(sender.view == otherappLabel){
        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.com/apps/TatsuoFujiwara"];
        [[UIApplication sharedApplication] openURL:url];
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"設定画面―他のアプリを見る" value:nil screen:@"設定画面"];
    }
}

/*
- (IBAction)searchAddress:(id)sender {
    // アドレス帳を呼び出す
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    if (status == kABAuthorizationStatusNotDetermined) {
        // 許可の判断をしていない場合
        ABAddressBookRequestAccessWithCompletion(NULL, ^(bool granted, CFErrorRef error) {
            if (granted) {
                //許可有効時
                [self openAddressBook];
            }
        });
    } else if (status == kABAuthorizationStatusRestricted || status == kABAuthorizationStatusDenied) {
        // アドレス帳へのアクセス制限とアクセス拒否の場合
        [Utility showAlert:@"連絡先へのアクセスが拒否されています。"];
    } else {
        // 許可が出ている場合
        [self openAddressBook];
    }
}

- (void)openAddressBook {
    ABPeoplePickerNavigationController *picker = [ABPeoplePickerNavigationController new];
    picker.peoplePickerDelegate = self;
    
    // iOS8以上の場合
    if([[[UIDevice currentDevice] systemVersion] compare:@"8" options:NSNumericSearch]
           == NSOrderedDescending){
        
        // メールアドレスだけ利用する
        picker.displayedProperties = @[@(kABPersonEmailProperty)];
        
        // メールアドレスを持ってない人を非表示にする
        picker.predicateForEnablingPerson = [NSPredicate predicateWithFormat:@"emailAddresses.@count > 0"];
        
        // この条件に一致した人は peoplePickerNavigationController:didSelectPerson の処理
        // 一致しない人は連絡帳の詳細画面に遷移してから peoplePickerNavigationController:didSelectPerson:property:identifier: の処理
        picker.predicateForSelectionOfPerson = [NSPredicate predicateWithFormat:@"emailAddresses.@count = 1"];
    }
    
    [self presentViewController:picker animated:YES completion: nil];
}

//閉じる
- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//選択時処理　ios8対応
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person];
}

//選択時処理
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    
    ABMutableMultiValueRef multi = ABRecordCopyValue(person, kABPersonEmailProperty);
    if (ABMultiValueGetCount(multi) > 1) {
        //複数メールアドレスが有る
        //メールアドレスだけを表示するようにして連絡帳の詳細画面に遷移する
        [peoplePicker setDisplayedProperties:[NSArray arrayWithObject:[NSNumber numberWithInt:kABPersonEmailProperty]]];
        CFRelease(multi);
        return YES;
    } else if (ABMultiValueGetCount(multi) == 1) {
        //メールアドレスが一件有る
        NSString *email = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(multi, 0));
        [self addAddress:email];
        
        [self dismissViewControllerAnimated:YES completion:nil];
        CFRelease(multi);
        return NO;
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
        CFRelease(multi);
        return NO;
    }
}

//詳細画面から戻った処理 ios8対応
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    [self peoplePickerNavigationController:peoplePicker shouldContinueAfterSelectingPerson:person property:property identifier:identifier];
}

//詳細画面から戻った処理
- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    ABMultiValueRef multi = ABRecordCopyValue(person, property);
    CFIndex index = ABMultiValueGetIndexForIdentifier(multi, identifier);
    
    NSString *email = (NSString*)CFBridgingRelease(ABMultiValueCopyValueAtIndex(multi, index));
    [self addAddress:email];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
    
    CFRelease(multi);
    return NO;
}

- (void)addAddress:(NSString*)email {
    NSMutableString* targetEmail = [NSMutableString string];
    
    if (_sendTo.text != nil){
        [targetEmail appendString:_sendTo.text];
    }
    
    if ([targetEmail isEqualToString:@""] == YES ||
        [targetEmail hasSuffix:@","] == YES){
        [targetEmail appendString:email];
    } else {
        [targetEmail appendString:@","];
        [targetEmail appendString:email];
    }
    
    _sendTo.text = targetEmail;
    
    [ConfigManager setDefaultSendTo:targetEmail];
}
*/

- (IBAction)sendUntreated:(id)sender {
    if([ConfigManager isSendMailFlg] == NO){
        [self showMoveAddonView:@"メール送信機能を利用するにはアドオンを購入してください。\n\nすでに購入済みの場合はアドオン購入画面からリストアをお試しください。"];
        return;
    }
    
    NSArray* targetKotsuhiList = [KotsuhiFileManager loadUntreatedList];
    [self sendMail:targetKotsuhiList sendAll:NO];
}

- (IBAction)sendAll:(id)sender {
    if([ConfigManager isSendMailFlg] == NO){
        [self showMoveAddonView:@"メール送信機能を利用するにはアドオンを購入してください。\n\nすでに購入済みの場合はアドオン購入画面からリストアをお試しください。"];
        return;
    }
    
    NSArray* targetKotsuhiList = [KotsuhiFileManager loadKotsuhiList];
    [self sendMail:targetKotsuhiList sendAll:YES];
}

- (void)showMoveAddonView:(NSString*)message {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
        message:message delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"アドオン購入画面へ", nil];
    alert.tag = ALERT_MOVE_ADDON;
    [alert show];
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
    
    // 交通費データをNSDataに変換（Windows用が指定されていた場合はSJISでエンコード）
    NSString* dataStr = [self makeCsvString:kotsuhiList];
    NSData* data = nil;
    if([ConfigManager isForWindows]){
        data = [dataStr dataUsingEncoding:NSShiftJISStringEncoding];
    } else {
        data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    // ファイルを作成して添付。MimeTypeはtext/csv
    NSString* fiilenameprefix = sendAll ? @"kotsuhiall" : @"kotsuhi";
    NSString* filename = [NSString stringWithFormat:@"%@%04d%02d%02d.csv",fiilenameprefix, year, month, day];
    [controller addAttachmentData:data mimeType:@"text/csv" fileName:filename];
    
    // メール送信用のビューを表示
    [self presentViewController:controller animated:YES completion:nil];
}

- (NSString*)makeCsvString:(NSArray*)kotsuhiList {
    NSMutableString* retString = [NSMutableString stringWithString:@""];

    [retString appendString:@"年,月,日,訪問先,出発地,到着地,交通手段,金額(片道),金額,往復,目的補足,経路,処理済"];
    if([ConfigManager isForWindows]){
        [retString appendString:@"\r"];
    }
    [retString appendString:@"\n"];
    
    for(Kotsuhi* kotsuhi in kotsuhiList){
        // 半角カンマを全角に置き換え
        NSString* visit = [Utility replaceComma:kotsuhi.visit];
        NSString* departure = [Utility replaceComma:kotsuhi.departure];
        NSString* arrival = [Utility replaceComma:kotsuhi.arrival];
        NSString* transportation = [Utility replaceComma:kotsuhi.transportation];
        NSString* purpose = [Utility replaceComma:kotsuhi.purpose];
        NSString* route = [Utility replaceComma:kotsuhi.route];
        
        [retString appendString:[NSString stringWithFormat:@"%d,%d,%d,%@,%@,%@,%@,%d,%d,%@,%@,%@,%@",
            kotsuhi.year, kotsuhi.month, kotsuhi.day, visit, departure, arrival, transportation,
            kotsuhi.amount, [kotsuhi getTripAmount], kotsuhi.roundtrip ? @"往復" : @"",
            purpose,route, kotsuhi.treated ? @"処理済" : @""]];
        if([ConfigManager isForWindows]){
            [retString appendString:@"\r"];
        }
        [retString appendString:@"\n"];
    }
    
    return retString;
}

// メール送信処理完了時のイベント
- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)mailSent {
    if(_sendAll == YES){
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"設定画面―メール送信（全件）" value:nil screen:@"設定画面"];
        [Utility showAlert:@"送信完了" message:@"メールを送信しました"];
    } else {
        [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"設定画面―メール送信（未処理）" value:nil screen:@"設定画面"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"送信完了"
            message:@"メールを送信しました。\n送信した交通費データを処理済にしますか？" delegate:self
            cancelButtonTitle:nil otherButtonTitles:@"変更しない", @"処理済にする", nil];
        alert.tag = ALERT_DONE;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(alertView.tag == ALERT_DONE){
        if(buttonIndex == 1){
            NSArray* untreatedKotsuhiList = [KotsuhiFileManager loadUntreatedList];
            for(Kotsuhi* kotsuhi in untreatedKotsuhiList){
                kotsuhi.treated = YES;
                [KotsuhiFileManager saveKotsuhi:kotsuhi];
            }
        
            [Utility showAlert:@"処理済に変更しました。"];
        
            [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"設定画面―メール送信後の処理済" value:nil screen:@"設定画面"];
        }
    } else if(alertView.tag == ALERT_MOVE_ADDON){
        if(buttonIndex == 1){
            [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"設定画面―アドオン入手画面へ遷移" value:nil screen:@"設定画面"];
            [self performSegueWithIdentifier:@"getaddon" sender:self];
        }
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
