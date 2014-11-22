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

@synthesize nadView;

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
    [AppDelegate adjustOriginForBeforeiOS6:selectMypatternView];
    
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
    selectMypatternView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:selectMypatternView];
    [AppDelegate adjustOriginForBeforeiOS6:selectMypatternView];
    
    // NADViewを表示
    [self.view addSubview:nadView];
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
    
    cell.textLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:18];
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    [nadView resume];
    
    [selectMypatternView deselectRowAtIndexPath:[selectMypatternView indexPathForSelectedRow] animated:NO];
    
    [self loadMyPatternList];
    [selectMypatternView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    //    [nadView pause];
}

- (void)dealloc {
    //    [nadView setDelegate:nil];
    //    nadView = nil;
}

- (IBAction)backButton:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
