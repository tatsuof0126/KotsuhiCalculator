//
//  UntreatedListViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2015/09/25.
//  Copyright (c) 2015年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ADG/ADGManagerViewController.h>

@interface UntreatedListViewController : UIViewController <ADGManagerViewControllerDelegate> {
    ADGManagerViewController *adg_;
}

@property (nonatomic, retain) ADGManagerViewController *adg;

@property (strong, nonatomic) IBOutlet UINavigationItem *listNavi;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBtn;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *registBtn;

- (IBAction)editButton:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *untreatedListView;

@property (strong, nonatomic) IBOutlet UITextView *initialText;

@property (strong, nonatomic, readwrite) NSMutableArray *untreatedListByMonth;
@property (strong, nonatomic, readwrite) NSMutableArray *untreatedMonthList;

@end
