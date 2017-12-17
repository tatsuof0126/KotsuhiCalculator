//
//  ConfigViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/28.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBoxButton.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ConfigViewController : UIViewController <GADBannerViewDelegate,ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) GADBannerView *gadView;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *transportationText;

@property (strong, nonatomic) IBOutlet UITextField *purposeText;

@property (strong, nonatomic) IBOutlet CheckBoxButton *iccardSearch;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *removeAdsBtn;

@property (strong, nonatomic) IBOutlet UILabel *reviewLabel;

@property (strong, nonatomic) IBOutlet UILabel *otherappLabel;

@property (strong, nonatomic) IBOutlet UINavigationItem *inputNavi;

@property (strong, nonatomic) IBOutlet UILabel *versionName;

- (IBAction)onTap:(id)sender;

@end
