//
//  PurchaseAddonViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/22.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "PurchaseAddonViewController.h"
#import "InAppPurchaseManager.h"
#import "AppDelegate.h"
#import "Utility.h"
#import "ConfigManager.h"
#import "TrackingManager.h"

#define APPSTORELABEL 1

@interface PurchaseAddonViewController ()

@end

@implementation PurchaseAddonViewController

@synthesize doingPurchase;
@synthesize actIndView;
@synthesize addonTableView;

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
    [TrackingManager sendScreenTracking:@"アドオン購入画面"];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
 	return 2;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section == 0){
        return @"アドオンを購入";
    } else if(section == 1){
        return @"以前にアドオンを購入済みの方";
    } else {
        return @"";
    }
}

-(NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    if(section == 0){
        return 2;
    } else if(section == 1){
        return 1;
    } else {
        return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    long section = indexPath.section;
    long row = indexPath.row;
    
    NSString* cellName = @"PurchaseCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                      reuseIdentifier:cellName];
    }
    
    NSString* text = @"";
    NSString* detailText = @"";
    
    if(section == 0 && row == 0){
        text = @"メール送信機能を追加する";
        if([ConfigManager isSendMailFlg] == YES){
            detailText = @"購入済み";
        }
    } else if(section == 0 && row == 1){
        text = @"広告を削除する";
        if([ConfigManager isRemoveAdsFlg] == YES){
            detailText = @"購入済み";
        }
    } else if(section == 1){
        text = @"購入済みアドオンをリストア";
    }
    
    cell.textLabel.text = text;
    cell.detailTextLabel.text = detailText;
    
    return cell;

    /*
    UITableViewCell* cell;
    
    NSString* cellName = [NSString stringWithFormat:@"%@%ld-%ld",@"PurchaseCell",section, row];
    cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:cellName];
    }
    
    if(section == 0){
        if(row == 0){
            cell.textLabel.text = @"メール送信機能を追加する";
        } else if (row == 1){
            cell.textLabel.text = @"広告を削除する";
        }
    } else if(section == 1){
        cell.textLabel.text = @"購入済みアドオンをリストア";
    }
    
    return cell;
     */
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //    NSLog(@"Selected %d-%d",indexPath.section, indexPath.row);
    
    if(indexPath.section == 0 && indexPath.row == 0){
        if([ConfigManager isSendMailFlg] == NO){
            [self requestAddon:@"com.tatsuo.KotsuhiCalculator.sendmail"];
        } else {
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
        }
    } else if(indexPath.section == 0 && indexPath.row == 1){
        if([ConfigManager isRemoveAdsFlg] == NO){
            [self requestAddon:@"com.tatsuo.KotsuhiCalculator.removeads"];
        } else {
            [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:NO];
        }
    } else if(indexPath.section == 1){
        [self restoreAddon];
    }
}

- (void)requestAddon:(NSString*)productId {
    [addonTableView deselectRowAtIndexPath:[addonTableView indexPathForSelectedRow] animated:NO];
    
    // 購入処理中なら処理しない
    if(doingPurchase == YES){
        return;
    }
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    InAppPurchaseManager* purchaseManager = [delegate getInAppPurchaseManager];
    
    // アプリ内課金が許可されていない場合はダイアログを出す
    if(purchaseManager.canMakePurchases == NO){
        [Utility showAlert:@"アプリ内での購入が許可されていません。設定を確認してください。"];
        return;
    }
    
    // 購入処理開始
    doingPurchase = YES;
    
    // InAppPurchaseManagerに自分自身の参照をセット
    purchaseManager.source = self;
    
    //ぐるぐるを出す
    actIndView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 60.0f, 60.0f)];
    [actIndView setCenter:self.view.center];
    [actIndView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];
    [self.view addSubview:actIndView];
    [actIndView startAnimating];
    
    // アプリ内課金を呼び出し
    [purchaseManager requestProductData:productId];
    
    [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"アドオン購入画面―広告を削除する" value:nil screen:@"アドオン購入画面"];
}

- (void)restoreAddon {
    [addonTableView deselectRowAtIndexPath:[addonTableView indexPathForSelectedRow] animated:NO];
    
    // 購入処理中なら処理しない
    if(doingPurchase == YES){
        return;
    }
    
    AppDelegate* delegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    InAppPurchaseManager* purchaseManager = [delegate getInAppPurchaseManager];
    
    // アプリ内課金が許可されていない場合はダイアログを出す
    if(purchaseManager.canMakePurchases == NO){
        [Utility showAlert:@"アプリ内での購入が許可されていません。設定を確認してください。"];
        return;
    }
    
    // 購入処理開始
    doingPurchase = YES;
    
    // InAppPurchaseManagerに自分自身の参照をセット
    purchaseManager.source = self;
    
    // アプリ内課金（リストア）を呼び出し
    [purchaseManager restoreProduct];
    
    [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"アドオン購入画面―購入済みアドオンをリストア" value:nil screen:@"アドオン購入画面"];
}

- (void)endConnecting {
    [actIndView stopAnimating];
}

- (void)endPurchase {
    doingPurchase = NO;
    [addonTableView reloadData];
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

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidUnload {
    [self setAddonTableView:nil];
    [super viewDidUnload];
}

@end
