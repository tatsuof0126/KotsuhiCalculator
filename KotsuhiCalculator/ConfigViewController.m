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

@interface ConfigViewController ()

@end

@implementation ConfigViewController

@synthesize nadView;
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
    
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    versionName.text = [NSString stringWithFormat:@"version%@",version];
    
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

    // すでに広告が非表示ならボタンを消す
    if([ConfigManager isRemoveAdsFlg] == YES){
        inputNavi.rightBarButtonItem = nil;
    }
    
    // AppStoreへリンクのタップを受け取るため
    reviewLabel.userInteractionEnabled = YES;
    [reviewLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];

    otherappLabel.userInteractionEnabled = YES;
    [otherappLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)]];

}

-(void)nadViewDidFinishLoad:(NADView *)adView {
    // NADViewの中身（広告）の読み込みに成功した場合
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

- (void)tapAction:(UITapGestureRecognizer*)sender{
    if(sender.view == reviewLabel){
//        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=578136103&mt=8&type=Purple+Software"];
        //        http://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=578136103&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8

//        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?id=578136103&pageNumber=0&sortOrdering=1&type=Purple+Software&mt=8"];
        
        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.apple.com/app/id881505236"];
        [[UIApplication sharedApplication] openURL:url];
    } else if(sender.view == otherappLabel){
        NSURL *url = [NSURL URLWithString:@"itms-apps://itunes.com/apps/TatsuoFujiwara"];
        [[UIApplication sharedApplication] openURL:url];
    }
}

@end
