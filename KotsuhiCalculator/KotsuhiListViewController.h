//
//  KotsuhiListViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/28.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ADG/ADGManagerViewController.h>

@interface KotsuhiListViewController : UIViewController <ADGManagerViewControllerDelegate> {
    ADGManagerViewController *adg_;
}

@property (nonatomic, retain) ADGManagerViewController *adg;

@property (strong, nonatomic) IBOutlet UITextView *initialText;

@property (strong, nonatomic) IBOutlet UITableView *kotsuhiListView;
@property (strong, nonatomic, readwrite) NSMutableArray *kotsuhiListByMonth;
@property (strong, nonatomic, readwrite) NSMutableArray *kotsuhiMonthList;

@end
