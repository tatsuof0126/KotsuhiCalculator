//
//  EditMailDetailViewController.h
//  KotsuhiCalculator
//
//  Created by 藤原 達郎 on 2017/11/27.
//  Copyright © 2017年 Tatsuo Fujiwara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMobileAds/GoogleMobileAds.h>

@interface EditMailDetailViewController : UIViewController <GADBannerViewDelegate>

@property (strong, nonatomic) GADBannerView *gadView;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray* dataItemArray;
@property BOOL edited;

- (IBAction)saveButton:(id)sender;

- (IBAction)initButton:(id)sender;

- (IBAction)backButton:(id)sender;

@end
