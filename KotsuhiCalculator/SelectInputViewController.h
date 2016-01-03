//
//  SelectInputViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2015/09/27.
//  Copyright (c) 2015年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ADG/ADGManagerViewController.h>

#define VISIT     1
#define DEPARTURE 2
#define ARRIVAL   3

@interface SelectInputViewController : UIViewController <ADGManagerViewControllerDelegate> {
    ADGManagerViewController *adg_;
}

@property (nonatomic, retain) ADGManagerViewController *adg;

@property int selectType;

@property (strong, nonatomic) IBOutlet UINavigationItem *naviItem;

@property (strong, nonatomic) IBOutlet UITableView *selectListView;

@property (strong, nonatomic) NSMutableArray* selectList;
@property (strong, nonatomic) UITextField* targetTextField;

- (IBAction)backButton:(id)sender;

@end