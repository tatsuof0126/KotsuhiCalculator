//
//  MyPatternListViewController.m
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/11.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import "MyPatternListViewController.h"
#import "AppDelegate.h"
#import "ConfigManager.h"
#import "KotsuhiFileManager.h"

#define REGIST_BTN 1

@interface MyPatternListViewController ()

@end

@implementation MyPatternListViewController

@synthesize nadView;

@synthesize mypatternListView;
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
    
    // TableViewの大きさ定義＆iPhone5対応
    mypatternListView.frame = CGRectMake(0, 64, 320, 366);
    [AppDelegate adjustForiPhone5:mypatternListView];
    [AppDelegate adjustOriginForBeforeiOS6:mypatternListView];
    
    if([ConfigManager isRemoveAdsFlg] == NO){
        // NADViewの作成（表示はこの時点ではしない）
        nadView = [[NADView alloc] initWithFrame:CGRectMake(0, 381, 320, 50)];
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
    mypatternListView.frame = CGRectMake(0, 64, 320, 316);
    [AppDelegate adjustForiPhone5:mypatternListView];
    [AppDelegate adjustOriginForBeforeiOS6:mypatternListView];
    
    // NADViewを表示
    [self.view addSubview:nadView];
}

- (void)loadMyPatternList {
    mypatternList = [KotsuhiFileManager loadMyPatternList];

    // マイパターンが0件の場合はメッセージを表示
    if(mypatternList.count == 0){
        _initialText.hidden = NO;
    } else {
        _initialText.hidden = YES;
    }
    
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
    NSString* cellName = @"MypatternCell";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellName];
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellName];
    }

    MyPattern* myPattern = [mypatternList objectAtIndex:indexPath.row];
    
    // メインテキスト
    NSString* viewText = [NSString stringWithFormat:@"%@ %@ %d円",
                          myPattern.patternName, myPattern.visit, myPattern.amount];
    
    cell.textLabel.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:16];
    
    NSMutableParagraphStyle *paragrahStyle = [[NSMutableParagraphStyle alloc] init];
    paragrahStyle.lineSpacing = - 2.0f;
    paragrahStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    NSMutableAttributedString *attributedText
    = [[NSMutableAttributedString alloc] initWithString:viewText];
    
    [attributedText addAttribute:NSParagraphStyleAttributeName
                           value:paragrahStyle
                           range:NSMakeRange(0, attributedText.length)];
    
    cell.textLabel.attributedText = attributedText;
    
    // サブテキスト
    NSString* viewDetailText = [NSString stringWithFormat:@" %@→%@(%@) %@ %@",
                                myPattern.departure, myPattern.arrival, myPattern.transportation, myPattern.purpose, myPattern.route];
    
    NSMutableAttributedString* detailStr
    = [[NSMutableAttributedString alloc] initWithString:viewDetailText];
    
    cell.detailTextLabel.attributedText = detailStr;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    targetField.text = [mypatternList objectAtIndex:indexPath.row];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue*)segue sender:(id)sender {
    AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    int tag = (int)((UIView*)sender).tag;
    if(tag == REGIST_BTN){
        // 追加ボタン
        appDelegate.targetMyPattern = nil;
    } else {
        // 個別のマイパターンを選択
        NSIndexPath* indexPath = [mypatternListView indexPathForSelectedRow];
        
        MyPattern* myPattern = [mypatternList objectAtIndex:indexPath.row];
        
        AppDelegate *appDelegate = (AppDelegate*)[[UIApplication sharedApplication] delegate];
        appDelegate.targetMyPattern = myPattern;
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        MyPattern* myPattern = [mypatternList objectAtIndex:indexPath.row];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
            message:@"削除してよろしいですか？" delegate:self cancelButtonTitle:@"キャンセル" otherButtonTitles:@"OK", nil];
        alert.tag = myPattern.mypatternid;
        [alert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if(buttonIndex == 1){
        int mypatternid = (int)alertView.tag;
        
        [KotsuhiFileManager removeMyPattern:mypatternid];
        
        [self loadMyPatternList];
        
        [mypatternListView reloadData];
    }
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [nadView resume];
    
    [mypatternListView deselectRowAtIndexPath:[mypatternListView indexPathForSelectedRow] animated:NO];
    
    [self loadMyPatternList];
    [mypatternListView reloadData];
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
