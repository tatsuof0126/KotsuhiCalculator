//
//  EditMailDetailViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2017/11/27.
//  Copyright © 2017年 Tatsuo Fujiwara. All rights reserved.
//

#import "EditMailDetailViewController.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "TrackingManager.h"
#import "Utility.h"
#import "KotsuhiFileManager.h"
#import "DataItem.h"

@interface EditMailDetailViewController ()

@end

@implementation EditMailDetailViewController

@synthesize gadView;
@synthesize tableView;
@synthesize dataItemArray;
@synthesize edited;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    dataItemArray = [KotsuhiFileManager loadDataItemList];
    
    [tableView setEditing:YES];
    
    // TableViewの大きさ定義＆iPhone5対応
    tableView.frame = CGRectMake(0, 120, 320, 360);
    [AppDelegate adjustForiPhone5:tableView];
    
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
    tableView.frame = CGRectMake(0, 120, 320, 310);
    [AppDelegate adjustForiPhone5:tableView];
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return dataItemArray.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    DataItem* dataItem = [dataItemArray objectAtIndex:indexPath.row];
    
    NSString* cellName = @"csvdetailcell";
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellName];
    }
    
    cell.textLabel.text = dataItem.name;
    
    // cell.selected = dataItem.usecsv;
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    DataItem* dataItem = [dataItemArray objectAtIndex:indexPath.row];
    dataItem.usecsv = YES;
    edited = YES;
}

- (void)tableView:(UITableView*)tableView didDeselectRowAtIndexPath:(NSIndexPath*)indexPath {
    DataItem* dataItem = [dataItemArray objectAtIndex:indexPath.row];
    dataItem.usecsv = NO;
    edited = YES;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath*)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
    NSMutableArray* newDataItemArray = [dataItemArray mutableCopy];
    
    DataItem* dataItem = [dataItemArray objectAtIndex:fromIndexPath.row];
    [newDataItemArray removeObjectAtIndex:fromIndexPath.row];
    [newDataItemArray insertObject:dataItem atIndex:toIndexPath.row];
    
    dataItemArray = newDataItemArray;
    
    edited = YES;
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

- (IBAction)saveButton:(id)sender {
    // チェックが０件だったらエラーメッセージ出す
    BOOL existUseCsv = NO;
    for(DataItem* dataItem in dataItemArray){
        if(dataItem.usecsv == YES){
            existUseCsv = YES;
        }
    }
    if(existUseCsv == NO){
        [Utility showAlert:@"１つ以上の項目にチェックをつける必要があります。"];
        return;
    }
    
    // 入力・編集していたら警告ダイアログを出す
    NSString* messageStr = @"編集内容を保存します。\nよろしいですか？";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleCancel handler:nil]];
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
        [self saveDataItem];
    }]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)initButton:(id)sender {
    dataItemArray = [DataItem getInitDataItemList];
    
    [tableView reloadData];
    [self selectRow];
    
    edited = YES;
}

- (void)saveDataItem {
    // orderを再設定
    int order = 1;
    for(DataItem* dataItem in dataItemArray){
        dataItem.order = order;
        order++;
    }
    
    [KotsuhiFileManager saveDataItemList:dataItemArray];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButton:(id)sender {
    if(edited == YES){
        // 入力・編集していたら警告ダイアログを出す
        NSString* messageStr = @"編集内容は保存されませんが、\nよろしいですか？";
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:messageStr preferredStyle:UIAlertControllerStyleAlert];
        [alertController addAction:[UIAlertAction actionWithTitle:@"キャンセル" style:UIAlertActionStyleCancel handler:nil]];
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)selectRow {
    // TableViewの初期選択状態を設定
    int count = 0;
    for(DataItem* dataItem in dataItemArray){
        if(dataItem.usecsv == YES){
            [tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:count inSection:0] animated:NO scrollPosition:UITableViewScrollPositionTop];
        }
        count++;
    }
    
    // TableViewのスクロールを一番上に戻す
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self selectRow];
}

@end
