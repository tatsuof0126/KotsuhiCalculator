//
//  ConfigViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2014/03/28.
//  Copyright (c) 2014年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CheckBoxButton.h"
#import <ADG/ADGManagerViewController.h>
#import <AddressBookUI/AddressBookUI.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ConfigViewController : UIViewController <ADGManagerViewControllerDelegate,ABPeoplePickerNavigationControllerDelegate, MFMailComposeViewControllerDelegate> {
    ADGManagerViewController *adg_;
}

@property (nonatomic, retain) ADGManagerViewController *adg;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UITextField *transportationText;

@property (strong, nonatomic) IBOutlet UITextField *purposeText;

@property (strong, nonatomic) IBOutlet CheckBoxButton *iccardSearch;

@property (strong, nonatomic) IBOutlet UITextField *sendTo;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *removeAdsBtn;

@property (strong, nonatomic) IBOutlet UILabel *reviewLabel;

@property (strong, nonatomic) IBOutlet UILabel *otherappLabel;

@property (strong, nonatomic) IBOutlet UINavigationItem *inputNavi;

@property (strong, nonatomic) IBOutlet UILabel *versionName;

- (IBAction)searchAddress:(id)sender;

- (IBAction)sendUntreated:(id)sender;

- (IBAction)sendAll:(id)sender;

@end
