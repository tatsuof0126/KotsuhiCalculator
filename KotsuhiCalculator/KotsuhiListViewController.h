//
//  KotsuhiListViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/28.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface KotsuhiListViewController : UIViewController <GADBannerViewDelegate>

@property (strong, nonatomic) GADBannerView *gadView;

@property (strong, nonatomic) IBOutlet UITextView *initialText;

@property (strong, nonatomic) IBOutlet UITableView *kotsuhiListView;
@property (strong, nonatomic, readwrite) NSMutableArray *kotsuhiListByMonth;
@property (strong, nonatomic, readwrite) NSMutableArray *kotsuhiMonthList;

@end
