//
//  MyPatternInputViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/05/11.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ADG/ADGManagerViewController.h>
#import "MyPattern.h"
#import "CheckBoxButton.h"

@interface MyPatternInputViewController : UIViewController <ADGManagerViewControllerDelegate> {
    ADGManagerViewController *adg_;
}

@property (nonatomic, retain) ADGManagerViewController *adg;

@property (strong, nonatomic) MyPattern* mypattern;
@property BOOL edited;

@property (strong, nonatomic) IBOutlet UITextField *patternName;
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

@property (strong, nonatomic) IBOutlet UIButton *registBtn;

- (IBAction)backButton:(id)sender;

- (IBAction)registButton:(id)sender;

@end
