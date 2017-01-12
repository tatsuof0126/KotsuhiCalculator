//
//  KotsuhiInputViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/28.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "Kotsuhi.h"
#import "CheckBoxButton.h"

@interface KotsuhiInputViewController : UIViewController <GADBannerViewDelegate>

@property (strong, nonatomic) GADBannerView *gadView;

@property (strong, nonatomic) Kotsuhi *kotsuhi;
@property BOOL edited;
@property int mypatternid;

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
@property (strong, nonatomic) IBOutlet CheckBoxButton *treated;
@property (strong, nonatomic) IBOutlet CheckBoxButton *registmypattern;
@property (strong, nonatomic) IBOutlet UILabel *treatedLabel;
@property (strong, nonatomic) IBOutlet UILabel *mypatternLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UINavigationItem *inputNavi;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *mypatternBtn;

@property (strong, nonatomic) IBOutlet UIButton *registBtn;

- (IBAction)registButton:(id)sender;

- (IBAction)changeButton:(id)sender;

- (IBAction)transitButton:(id)sender;

- (IBAction)backButton:(id)sender;

- (IBAction)onTap:(id)sender;

@end
