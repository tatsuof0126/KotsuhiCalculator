//
//  KotsuhiInputViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/28.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Kotsuhi.h"
#import "NADView.h"
#import "CheckBoxButton.h"

@interface KotsuhiInputViewController : UIViewController <NADViewDelegate>

@property (nonatomic, retain) NADView* nadView;

@property (strong, nonatomic) Kotsuhi *kotsuhi;
@property BOOL edited;

@property (strong, nonatomic) IBOutlet UITextField *year;
@property (strong, nonatomic) IBOutlet UITextField *month;
@property (strong, nonatomic) IBOutlet UITextField *day;
@property (strong, nonatomic) IBOutlet UITextField *visit;
@property (strong, nonatomic) IBOutlet UITextField *departure;
@property (strong, nonatomic) IBOutlet UITextField *arrival;
@property (strong, nonatomic) IBOutlet UITextField *transportation;
@property (strong, nonatomic) IBOutlet UITextField *amount;
@property (strong, nonatomic) IBOutlet UITextField *purpose;
@property (strong, nonatomic) IBOutlet UITextField *route;
@property (strong, nonatomic) IBOutlet CheckBoxButton *roundtrip;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UINavigationItem *inputNavi;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mypatternBtn;

- (IBAction)registButton:(id)sender;

- (IBAction)backButton:(id)sender;

@end
