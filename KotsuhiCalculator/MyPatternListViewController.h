//
//  MyPatternListViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/11.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"

@interface MyPatternListViewController : UIViewController <NADViewDelegate>

@property (nonatomic, retain) NADView* nadView;

@property (strong, nonatomic) IBOutlet UITableView *mypatternListView;
@property (strong, nonatomic) IBOutlet UITextView *initialText;

@property (strong, nonatomic, readwrite) NSArray *mypatternList;

@end
