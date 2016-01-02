//
//  MyPatternListViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/11.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ADG/ADGManagerViewController.h>

@interface MyPatternListViewController : UIViewController <ADGManagerViewControllerDelegate> {
    ADGManagerViewController *adg_;
}

@property (nonatomic, retain) ADGManagerViewController *adg;

@property (strong, nonatomic) IBOutlet UINavigationItem *mypatternNavi;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *registBtn;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *editBtn;

- (IBAction)editButton:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *mypatternListView;
@property (strong, nonatomic) IBOutlet UITextView *initialText;

@property (strong, nonatomic, readwrite) NSArray *mypatternList;

@end
