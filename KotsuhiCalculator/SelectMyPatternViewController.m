//
//  SelectMyPatternViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/20.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "SelectMyPatternViewController.h"
#import "KotsuhiInputViewController.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "KotsuhiFileManager.h"
#import "TrackingManager.h"

@interface SelectMyPatternViewController ()

@end

@implementation SelectMyPatternViewController

@synthesize selectMypatternView;
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
    [TrackingManager sendScreenTracking:@"マイパターン選択画面"];
    
    // TableViewの大きさ定義＆iPhone5対応
    selectMypatternView.frame = CGRectMake(0, 64, 320, 416);
    [AppDelegate adjustForiPhone5:selectMypatternView];
//    [AppDelegate adjustOriginForBeforeiOS6:selectMypatternView];
    
    // 広告表示（AppBankSSP）
    if(AD_VIEW == 1 && [ConfigManager isRemoveAdsFlg] == NO){
        NSDictionary *adgparam = @{@"locationid" : @"28513", @"adtype" : @(kADG_AdType_Sp),
                                   @"originx" : @(0), @"originy" : @(581), @"w" : @(320), @"h" : @(50)};
        ADGManagerViewController *adgvc = [[ADGManagerViewController alloc] initWithAdParams:adgparam adView:self.view];
        self.adg = adgvc;
        _adg.delegate = self;
        [_adg setFillerRetry:NO];
        [_adg loadRequest];
    }
}

- (void)ADGManagerViewControllerReceiveAd:(ADGManagerViewController *)adgManagerViewController {
    // 読み込みに成功したら広告を見える場所に移動
    self.adg.view.frame = CGRectMake(0, 431, 320, 50);
    [AppDelegate adjustOriginForiPhone5:self.adg.view];
//    [AppDelegate adjustOriginForBeforeiOS6:self.adg.view];
    
    // TableViewの大きさ定義＆iPhone5対応
    selectMypatternView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:selectMypatternView];
//    [AppDelegate adjustOriginForBeforeiOS6:selectMypatternView];
}

- (void)loadMyPatternList {
    mypatternList = [KotsuhiFileManager loadMyPatternList];
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return mypatternList.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString* cellName = @"SelectMypatternCell";
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
    
    cell.textLabel.font = [UIFont fontWithName:@"HiraKakuProN-W3" size:18];
    cell.textLabel.attributedText = attributedText;
    
    // サブテキスト
    NSString* viewDetailText = [NSString stringWithFormat:@" %@%@%@(%@) %@ %@",
                                myPattern.departure, [myPattern getTripArrow], myPattern.arrival, myPattern.transportation, myPattern.purpose, myPattern.route];
    
    NSMutableAttributedString* detailStr
    = [[NSMutableAttributedString alloc] initWithString:viewDetailText];
    
    cell.detailTextLabel.attributedText = detailStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [TrackingManager sendEventTracking:@"Button" action:@"Push" label:@"マイパターン選択画面―選択" value:nil screen:@"マイパターン選択画面"];
    
    MyPattern* myPattern = [mypatternList objectAtIndex:indexPath.row];
    
    KotsuhiInputViewController* viewController = (KotsuhiInputViewController*)[self presentingViewController];
    viewController.visit.text = myPattern.visit;
    viewController.departure.text = myPattern.departure;
    viewController.arrival.text = myPattern.arrival;
    viewController.transportation.text = myPattern.transportation;
    viewController.amount.text = [NSString stringWithFormat:@"%d", myPattern.amount];
    viewController.purpose.text = myPattern.purpose;
    viewController.route.text = myPattern.route;
    viewController.roundtrip.checkBoxSelected = myPattern.roundtrip;
    [viewController.roundtrip setState];
    
    viewController.mypatternid = myPattern.mypatternid;
    viewController.mypatternLabel.text = @"マイパターンを更新";
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [selectMypatternView deselectRowAtIndexPath:[selectMypatternView indexPathForSelectedRow] animated:NO];
    
    [self loadMyPatternList];
    [selectMypatternView reloadData];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if(_adg){
        [_adg resumeRefresh];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    if(adg_){
        [adg_ pauseRefresh];
    }
}

- (void)dealloc {
    adg_.delegate = nil;
    adg_ = nil;
}

@end
