//
//  SelectInputViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2015/09/27.
//  Copyright (c) 2015年 Tatsuo Fujiwara. All rights reserved.
//

#import "SelectInputViewController.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "KotsuhiFileManager.h"
#import "TrackingManager.h"
#import "KotsuhiInputViewController.h"

@interface SelectInputViewController ()

@end

@implementation SelectInputViewController

@synthesize gadView;
@synthesize selectType;
@synthesize targetTextField;
@synthesize selectList;
@synthesize selectListView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 画面が開かれたときのトラッキング情報を送る
    [TrackingManager sendScreenTracking:[self getTitleString]];
    
    _naviItem.title = [self getTitleString];
    [self makeSelectList];
    
    // TableViewの大きさ定義＆iPhone5対応
    selectListView.frame = CGRectMake(0, 64, 320, 416);
    [AppDelegate adjustForiPhone5:selectListView];
    
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
    selectListView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:selectListView];
}

- (NSString*)getTitleString {
    NSString* str = @"";
    if (selectType == VISIT){
        str = @"訪問先を選択";
    } else if (selectType == DEPARTURE) {
        str = @"出発地を選択";
    } else if (selectType == ARRIVAL) {
        str = @"到着地を選択";
    } else if (selectType == PURPOSE) {
        str = @"目的補足を選択";
    }
    
    return str;
}

- (void)makeSelectList {
    selectList = [NSMutableArray array];

    NSArray* kotsuhiList = [KotsuhiFileManager loadKotsuhiList];
    for(Kotsuhi* kotsuhi in kotsuhiList){
        NSString* str1 = @"";
        NSString* str2 = @"";
        if (selectType == VISIT){
            str1 = kotsuhi.visit;
            str2 = @"";
        } else if (selectType == DEPARTURE || selectType == ARRIVAL) {
            str1 = kotsuhi.departure;
            str2 = kotsuhi.arrival;
        } else if (selectType == PURPOSE) {
            str1 = kotsuhi.purpose;
            str2 = @"";
        }
        
        if([str1 isEqualToString:@""] == NO && [selectList containsObject:str1] == NO){
            [selectList addObject:str1];
        }
        if([str2 isEqualToString:@""] == NO && [selectList containsObject:str2] == NO){
            [selectList addObject:str2];
        }
    }
}

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return selectList.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"SelectInputCell"];
    cell.textLabel.text = [selectList objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath {
    targetTextField.text = [selectList objectAtIndex:indexPath.row];
    
    // 出発地・到着地の場合はKotsuhiInputViewControllerにある金額の自動セットメソッドを呼ぶ
    if (selectType == DEPARTURE || selectType == ARRIVAL){
        KotsuhiInputViewController* controller = (KotsuhiInputViewController*)self.presentingViewController;
        [controller fulfillAmount];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    gadView.delegate = nil;
    gadView = nil;
}

@end
