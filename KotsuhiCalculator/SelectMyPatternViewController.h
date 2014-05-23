//
//  SelectMyPatternViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/20.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NADView.h"

@interface SelectMyPatternViewController : UIViewController <NADViewDelegate>

@property (nonatomic, retain) NADView* nadView;

@property (strong, nonatomic) IBOutlet UITableView *selectMypatternView;

@property (strong, nonatomic, readwrite) NSArray *mypatternList;

- (IBAction)backButton:(id)sender;

@end
