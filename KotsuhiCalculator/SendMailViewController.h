//
//  SendMailViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2017/11/26.
//  Copyright © 2017年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBoxButton.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface SendMailViewController : UIViewController
    <GADBannerViewDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) GADBannerView *gadView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UINavigationItem *inputNavi;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *addonBtn;

@property (strong, nonatomic) IBOutlet UITextField *sendTo;

@property (strong, nonatomic) IBOutlet CheckBoxButton *forWindows;

@property BOOL sendAll;

@end
